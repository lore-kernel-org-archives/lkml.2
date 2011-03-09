Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756Ab1CIXWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 18:22:40 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43319 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab1CIXWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 18:22:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=T1MLVCNX2TTSdWK142UGqAtzkqhvG/dhl1voMwJYLnUDdP+0/zeKtvRPqzI0hzQaIr
         w0nQJoWVjYlX/jaLQNtLUJCTYER01bbbSiIC5hKUWFuKY9nzv2Wth/5o6EodGjpzIHiM
         MWX0qVRHeMALp2JgqsXLqGEupvdLNy6yX3Hso=
Date: Thu, 10 Mar 2011 01:22:33 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: make struct proc_dir_entry::namelen unsigned int
Message-ID: <20110309232233.GA24596@p183.telecom.by>
References: <20110308105428.GA5767@p183.telecom.by>
 <20110309150306.90369913.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110309150306.90369913.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 03:03:06PM -0800, Andrew Morton wrote:
> On Tue, 8 Mar 2011 12:54:28 +0200
> Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > Space is not really conserved, because of natural alignment for the next field.
> > sizeof(struct proc_dir_entry) remains the same.
> > 
> 
> What is the reason for this patch??

1. namelen is declared "unsigned short" which hints for "maybe space savings".
   Indeed in 2.4 struct proc_dir_entry looked like:

	struct proc_dir_entry {
		unsigned short low_ino;
		unsigned short namelen;

   Now, low_ino is "unsigned int", all savings were gone for a long time.
   "struct proc_dir_entry" is not that countless to worry about it's size,
   anyway.

2. converting from unsigned short to int/unsigned int can only create
   problems, we better play it safe.
