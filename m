Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab0I2HCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 03:02:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62268 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab0I2HCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 03:02:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=NM1LYhi2tLGuo3XhP6C6km0SBHLklb0VqADp7z7yYNnnPuOGBmtmGEmaQb8JQYcNF4
         lQ5jSK9eOrN8KePZgna/T2dQ+kbZ+WQ7F/Vgn9hvsh4g3Y6wvypGD2qpWfQnILPtzFuM
         1M6iNywr7AfZPD6U5xd2/QMaKREjoastw1bIo=
Date: Wed, 29 Sep 2010 15:06:31 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] namespace.pl: fix source tree name mangling
Message-ID: <20100929070631.GE5169@cr0.nay.redhat.com>
References: <20100928084400.997539242@vyatta.com>
 <20100928084528.884369764@vyatta.com>
 <20100929043112.GB5169@cr0.nay.redhat.com>
 <20100929141153.551a4851@s6510>
 <20100929060427.GD5169@cr0.nay.redhat.com>
 <20100929150645.75b7e390@s6510>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100929150645.75b7e390@s6510>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 03:06:45PM +0900, Stephen Hemminger wrote:
>On Wed, 29 Sep 2010 14:04:27 +0800
>Américo Wang <xiyou.wangcong@gmail.com> wrote:
>
>> On Wed, Sep 29, 2010 at 02:11:53PM +0900, Stephen Hemminger wrote:
>> >On Wed, 29 Sep 2010 12:31:12 +0800
>> >Américo Wang <xiyou.wangcong@gmail.com> wrote:
>> >
>> >> On Tue, Sep 28, 2010 at 05:44:02PM +0900, Stephen Hemminger wrote:
>> >> >The current namespace.pl script does not find source files correctly.
>> >> >The problem is that the current directory is not the base of the kernel
>> >> >tree at the point where it calls objdump.
>> >> >
>> >> >Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
>> >> >
>> >> >--- a/scripts/namespace.pl	2010-09-27 17:53:29.919433444 +0900
>> >> >+++ b/scripts/namespace.pl	2010-09-28 09:24:36.891552993 +0900
>> >> >@@ -167,8 +167,10 @@ sub do_nm
>> >> > 		printf STDERR "$fullname is not an object file\n";
>> >> > 		return;
>> >> > 	}
>> >> >-	($source = $fullname) =~ s/\.o$//;
>> >> >-	if (-e "$objtree$source.c" || -e "$objtree$source.S") {
>> >> >+	$fullname =~ s/\.o$//;
>> >> >+	$source = $basename;
>> >> >+	$source =~ s/\.o$//;
>> >> 
>> >> With your patch applied, $source will be the basename of
>> >> an obj path with .o stripped.
>> >> 
>> >> >+	if (-e "$objtree$fullname.c" || -e "$objtree$fullname.S") {
>> >> > 		$source = "$objtree$source";
>> >> > 	} else {
>> >> > 		$source = "$srctree$source";
>> >> >
>> >> 
>> >> So here we will get a non-exist path stored in $source.
>> >> 
...
>> 
>> I see, the docs of Find module said it will do chdir. :)
>> But I think your patch is still not right, how about the
>> one below?
>
>Please be more precise about "not right"? It makes the code
>work.
>

Hmm? $srctree is the path of top source code, and $source
is the basename of an object, so dirname is missed, no?

Thanks.
