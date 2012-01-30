Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab2A3Qjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 11:39:44 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:50480 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab2A3Qjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 11:39:43 -0500
Date: Mon, 30 Jan 2012 11:39:25 -0500
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: checkpatch.pl: WxV false positive
Message-ID: <20120130113925.5830f89d@v0nbox>
In-Reply-To: <20120130111817.GA18810@localhost>
References: <20120122214834.6414592c@lenov0n>
	<20120130111817.GA18810@localhost>
Organization: Savoir-faire Linux Inc.
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On Mon, 30 Jan 2012 11:18:17 +0000,
Andy Whitcroft <apw@canonical.com> wrote:

> On Sun, Jan 22, 2012 at 09:48:34PM -0500, Vivien Didelot wrote:
> 
> > In the code below, checkpatch thinks that the asterisk is a
> > multiplication, so it is complaining about coding style.
> > 
> >     ERROR: need consistent spacing around '*' (ctx:WxV)
> >     #304: FILE: x86/platform/ts5500/ts5500_adc.c:304:
> >     +	.attrs = (struct attribute *[]) {
> 
> C types are the pits.  How does the version below handle for you:
> 
>     http://people.canonical.com/~apw/checkpatch/checkpatch-next.pl
> 

This version works for me!

> Relative patch below.
> 
> -apw
> 
> commit f8a73045dcaac70f9be770cca06f21c762a13878
> Author: Andy Whitcroft <apw@canonical.com>
> Date:   Sun Jan 29 21:46:04 2012 +0000
> 
>     checkpatch: add [] to type extensions
>     
>     Add [] to a type extensions.  Fixes false positives on:
>     
>         .attrs = (struct attribute *[]) {
>     
>     Signed-off-by: Andy Whitcroft <apw@canonical.com>
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index d1dd544..64de1bd 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -323,7 +323,7 @@ sub build_types {
>  		  }x;
>  	$Type	= qr{
>  			$NonptrType
> -			(?:[\s\*]+\s*const|[\s\*]+|(?:\s*\[\s*\])+)?
> +
> (?:(?:\s|\*|\[\])+\s*const|(?:\s|\*|\[\])+|(?:\s*\[\s*\])+)?
> (?:\s+$Inline|\s+$Modifier)* }x;
>  	$Declare	= qr{(?:$Storage\s+)?$Type};

Thanks,
Vivien

-- 
Vivien Didelot
Savoir-faire Linux Inc.
Tel: (514) 276-5468 #149
