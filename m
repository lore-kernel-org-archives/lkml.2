Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab0JKTky (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 15:40:54 -0400
Received: from kroah.org ([198.145.64.141]:55507 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755216Ab0JKTkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 15:40:53 -0400
Date: Mon, 11 Oct 2010 12:39:15 -0700
From: Greg KH <greg@kroah.com>
To: Frank Salomon <frank.salomon@wincor-nixdorf.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: driver or calculation of load average wrong ?
Message-ID: <20101011193915.GA9820@kroah.com>
References: <4CB2ADB1.6070401@wincor-nixdorf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB2ADB1.6070401@wincor-nixdorf.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 08:24:49AM +0200, Frank Salomon wrote:
> Hello All,
>
> I have the following configuration:
> - CentOS 5
> - kernel 2.6.20.1
> - My own driver in a kernel_thread:
> 		while ( 1 ){
> 			printk ( KERN_INFO "go sleep, %lu\n", jiffies );
> 			current -> state = TASK_UNINTERRUPTIBLE;
> 			schedule_timeout ( msecs_to_jiffies(4000) );

Change this to schedule_timeout_interruptable() and your load average
calculation will go back to what you expect it to.

hope this helps,

greg k-h
