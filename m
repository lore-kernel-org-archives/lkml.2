Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab1BTNKL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 08:10:11 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57752 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab1BTNKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 08:10:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=juucNXFWh9MZqLvhBQqDNM53/DzWu4FQmwk40COZwR0qskfWaznoxxRD0ZTm+MTTnh
         +h4soJmRgC/sbyMBNhVzjwtASnquvLcKo4hyFq7ScFYqWLSWIzczoafdw5+4plTNg86/
         6PwvQmj1UI++ezZXq1Thm9n79cvpeCE0gqV04=
Date: Sun, 20 Feb 2011 16:09:50 +0300
From: Dan Carpenter <error27@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        "open list:AMD MICROCODE UPD..." <amd64-microcode@amd64.org>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch -next] x86, microcode, AMD: signedness bug in
 generic_load_microcode()
Message-ID: <20110220130950.GC1898@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Ingo Molnar <mingo@elte.hu>,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Borislav Petkov <borislav.petkov@amd.com>,
	"maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
	"open list:AMD MICROCODE UPD..." <amd64-microcode@amd64.org>,
	open list <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
References: <20110218091716.GA4384@bicker>
 <20110220130214.GD25700@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110220130214.GD25700@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 20, 2011 at 02:02:14PM +0100, Ingo Molnar wrote:
> 
> * Dan Carpenter <error27@gmail.com> wrote:
> 
> > install_equiv_cpu_table() returns type int.  It uses negative error
> > codes so using an unsigned type breaks the error handling.
> 
> How did you notice this btw - did GCC throw a warning?
> 

It's a smatch warning.

arch/x86/kernel/microcode_amd.c +256 generic_load_microcode(12)
	warn: unsigned 'offset' is never less than zero.

regards,
dan carpenter
