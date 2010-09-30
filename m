Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab0I3J7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 05:59:35 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:58337 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab0I3J7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 05:59:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sB0plkXQZSVcr7JNSgrI0asy+1wdMRmslsQa9dT34Ll4JRLjt5Lqm1DsTgdhWgKUlq
         tSbnNDWPLDQRv1vWhtxFHWzeoirwck033r9SD7Otg7ZrXt2W61O3IwUwrDqoCJhziBTH
         702hDdft19+pQSevjeAfoWRXv+SOq/q4dcX80=
Date: Thu, 30 Sep 2010 18:04:05 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Andreas Saebjoernsen <andreas@digitalplaywright.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: interpreting semantics of ipc system call
Message-ID: <20100930100405.GB5265@cr0.nay.redhat.com>
References: <AANLkTik8auzhRB00fRWxbmZKOKg+T87ZZa07ydDAGp=f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik8auzhRB00fRWxbmZKOKg+T87ZZa07ydDAGp=f@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 03:03:11PM -0700, Andreas Saebjoernsen wrote:
>We are developing a simulator that can simulate any specimen x86 linux program.
>Our simulator has a simulated memory, unlike the concrete memory state of
>tools like Valgrind, so that we can do concrete symbolic execution. Instead of
>reimplementing the system calls we marshal the system calls called by
>the specimen.
>
>I am currently working on marshaling calls to the ipc system call (system
>call 117) which has the following signature
>
>int ipc(unsigned int call, int first, int second, int third, void
>*ptr, long fifth)
>
>I have a problem interpreting what the size is of the data structure
>pointed to by
>the 'void*', and I have been unable to locate good documentation or code on the
>semantics of this system call.


Take a look at ipc/syscall.c, that pointer will be interpreted to different
data structures when you pass different arguments to 'call'.
