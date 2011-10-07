Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965382Ab1JGKlC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 06:41:02 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49583 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759857Ab1JGKlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 06:41:00 -0400
Date: Fri, 7 Oct 2011 11:38:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, lennart@poettering.net, harald@redhat.com,
        david@fubar.dk, greg@kroah.com
Subject: Re: A =?UTF-8?B?UGx1bWJlcuKAmXM=?= Wish List for Linux
Message-ID: <20111007113820.3b8424a8@lxorguk.ukuu.org.uk>
In-Reply-To: <CAPXgP12nDB2NX6hZabmkUZA9n0PZadi6Yv70LNms8fz9+MnVoA@mail.gmail.com>
References: <1317943022.1095.25.camel@mop>
	<20111007111231.6e11d18e@lxorguk.ukuu.org.uk>
	<CAPXgP12nDB2NX6hZabmkUZA9n0PZadi6Yv70LNms8fz9+MnVoA@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Oct 2011 12:28:46 +0200
Kay Sievers <kay.sievers@vrfy.org> wrote:

> On Fri, Oct 7, 2011 at 12:12, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >> * (ioctl based?) interface to query and modify the label of a mounted
> >> FAT volume:
> >
> > Seems sensible - or it could go in sysfs ?
> 
> That would mean to export superblocks in /sys, which isn't namespaced,
> and which might create issues by making information globally available
> which probably shouldn't?

Possibly, otherwise you really need an ioctl on the root inode of the fs
- which is doable, NCPfs makes heavy use of that.
> 
> >> A FAT labels is implemented as a hidden directory entry in the file
> >> system which need to be renamed when changing the file system label,
> >
> > That would be ugly - it works for FAT as you can create an imaginary name
> > which is not possible on the fs, but that isn't true for say ext4. Sysfs
> > sounds the logic way, it means adding chunks of code to various file
> > systems.
> 
> What do you mean would be ugly?

I have an ext4fs. It supports every possible file name allowed by POSIX
and SuS. What name are you going to use for your 'hidden directory' that
won't clash with a real file ?

