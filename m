Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab0EMWKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 18:10:13 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42416 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab0EMWKL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 18:10:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Mw5yX2KpjaOy4+0hq1JQz9nJwyJXYU6bGeWIyWjpd+oSX9e8YOK2vJJJkCGoeLdnWe
         5U1qgZysSo4uRGiJtGkuKxBYI26ow9QEvvVLCJFV7jZge8vtrm/MeyfYsTA/h0m3FOr0
         hFX2pL9tW3cYnuVF3iF2SNV2rO7NXvL1cFlVY=
MIME-Version: 1.0
In-Reply-To: <20100513214621.GA2124@ghostprotocols.net>
References: <AANLkTins2yCK-rvmdaaSQoBum4haHLhPx34EeJDg21Gg@mail.gmail.com>
	 <20100513145826.GJ30926@ghostprotocols.net>
	 <AANLkTin1w6OoS_6qzMqIizBxOGiV7DXJ936-hdHSFCD8@mail.gmail.com>
	 <20100513173426.GK19192@ghostprotocols.net>
	 <4BEC6DC2.4040207@redhat.com>
	 <20100513214621.GA2124@ghostprotocols.net>
Date: Fri, 14 May 2010 00:10:10 +0200
X-Google-Sender-Auth: gRvf2YD2mEOVgK4cLYP78Y8okdY
Message-ID: <AANLkTin6jSCh7Dqk_uoft7vWwiEoyJPBBAFXpnQiCQjT@mail.gmail.com>
Subject: Re: perf: relative path to source for perf probe?
From: Chase Douglas <chase.douglas@canonical.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 11:46 PM, Arnaldo Carvalho de Melo
<acme@ghostprotocols.net> wrote:
> IOW:
>
> real_path = user_provided_path + (DW_AT_name - DW_AT_comp_dir)
>
> + == concat
>
> - remove initial string
>
> if the project is build in place, i.e. in the kernel case, when one
> doesn't use 'make O='
>
> But then, given user_provided_path what we can do is to find a match
> from the end of DW_AT_name, thus infering the missing (non-existent in
> DWARF) DW_AT_source_dir tag :-)
>
>> In this case (after compiling kernel, user moved its source into another
>> directory), we have to find the top directory of this source code.
>>
>> Imagine that, if user compiled code under /home/user/git-ksrc/, and
>> it was moved under  /usr/src/2.6.x/, perf probe will be given an option
>> '-s /usr/src/2.6.x/'.
>
> So, for the DW_AT_name example above, we would have these files:
>
> At build time (DW_AT_name):
>
> /home/acme_unencrypted/git/linux-2.6-tip/arch/x86/kernel/head_64.S
>
> And at analysis time (using the path where the user moved all the source
> tree):
>
> /usr/src/2.6.x/arch/x86/kernel/head_64.S
>
> Putting then side by side:
>
> /home/acme_unencrypted/git/linux-2.6-tip/arch/x86/kernel/head_64.S
>                          /usr/src/2.6.x/arch/x86/kernel/head_64.S
>
> So know we know what DW_AT_source_dir is.
>
> Implementation is left to the reader 8-)

Thank you both for this discussion! I think I have enough information
to try to create an implementation. Now I just need to find the time
to do it :).

-- Chase
