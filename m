Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab1HLIxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 04:53:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38398 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751830Ab1HLIxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 04:53:46 -0400
Date: Fri, 12 Aug 2011 09:56:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dongsu Park <dongsu.park@profitbricks.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Liu Yuan <namei.unix@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] vhost-blk: An in-kernel accelerator for virtio-blk
Message-ID: <20110812095649.2885f54d@lxorguk.ukuu.org.uk>
In-Reply-To: <4E44349D.9030809@profitbricks.com>
References: <1311863346-4338-1-git-send-email-namei.unix@gmail.com>
	<1311863346-4338-2-git-send-email-namei.unix@gmail.com>
	<20110728152244.GA31888@redhat.com>
	<4E44349D.9030809@profitbricks.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Aug 2011 21:59:25 +0200
Dongsu Park <dongsu.park@profitbricks.com> wrote:

> Hi,
> 
> On 07/28/2011 05:22 PM, Michael S. Tsirkin wrote:
> > On Thu, Jul 28, 2011 at 10:29:05PM +0800, Liu Yuan wrote:
> >> +static struct miscdevice vhost_blk_misc = {
> >> +	234,
> >
> > Don't get a major unless you really must.
> 
> the minor number 234 conflicts with that of BTRFS, in kernel 3.0 at least.
> Therefore you cannot load vhost_blk.ko if btrfs.ko was already loaded.
> Probably that number should be something else, with which you don't have 
> conflict with any minor number in include/linux/miscdevice.h.

It should be zero or it should be officially reserved in devices.txt via
lanana@kernel.org, who (for it happens to be me currently) will turn it
down and tell you to use 0 to get a dynamic allocation unless you can
provide a very good reason that isn't suitable.
