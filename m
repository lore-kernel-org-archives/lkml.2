Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab1G1PSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:18:16 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40229 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab1G1PSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:18:12 -0400
MIME-Version: 1.0
In-Reply-To: <1311863346-4338-2-git-send-email-namei.unix@gmail.com>
References: <1311863346-4338-1-git-send-email-namei.unix@gmail.com>
	<1311863346-4338-2-git-send-email-namei.unix@gmail.com>
Date: Thu, 28 Jul 2011 16:18:12 +0100
Message-ID: <CAJSP0QWefz1u9qwevKOoCQ2ZW3iaEErGatwCM72y0xr=vQgpSA@mail.gmail.com>
Subject: Re: [RFC PATCH] vhost-blk: An in-kernel accelerator for virtio-blk
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Liu Yuan <namei.unix@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 3:29 PM, Liu Yuan <namei.unix@gmail.com> wrote:
> +static int blk_completion_worker(void *priv)
> +{

Do you really need this?  How about using the vhost poll helper to
observe the eventfd?  Then you can drop your own worker thread code
and simply have a work function to handle all pending completions
events.

Stefan
