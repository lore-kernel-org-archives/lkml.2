Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab0HKOFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 10:05:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54113 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab0HKOFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 10:05:17 -0400
Date: Wed, 11 Aug 2010 15:05:15 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Davidlohr Bueso <dave@gnu.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kay.sievers@vrfy.org, gregkh@suse.de
Subject: Re: [PATCH] kernel/ksysfs: use snprintf for sysfs show
Message-ID: <20100811140515.GH31363@ZenIV.linux.org.uk>
References: <1281534250.2067.14.camel@cowboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281534250.2067.14.camel@cowboy>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 09:44:10AM -0400, Davidlohr Bueso wrote:
> Use snprintf(buf, PAGE_SIZE, ...) instead of sprintf for sysfs show
> methods.  This is suggested in Documentation/filesystems/sysfs.txt

... therefore it must be done, the common sense be damned.

> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> ---

>  static ssize_t uevent_seqnum_show(struct kobject *kobj,
>  				  struct kobj_attribute *attr, char *buf)
>  {
> -	return sprintf(buf, "%llu\n", (unsigned long long)uevent_seqnum);
> +	return snprintf(buf, PAGE_SIZE, "%llu\n", 
> +			(unsigned long long)uevent_seqnum); 

A-yup - that's an improvement, all right, on them evil boxen that got
long long so huge that its decimal representation won't fit into a page.

NAK.  Cargo-cult programming is bad.
