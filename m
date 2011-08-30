Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751309Ab1H3A1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 20:27:30 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:37821 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab1H3A1X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 20:27:23 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MVSH9HKdKFpw1dxKRHV1grPEMjnNbrAbE73yLrZbgYHcg@mail.gmail.com>
References: <alpine.LNX.2.00.1107311134490.30666@linux>
	<CACqU3MX7f2oNpDf6W124tfROfKq4PFsyvxiq=VtPJfv-gqUrww@mail.gmail.com>
	<CACqU3MU9BBsXjevz617v7YOBm+9RR1Wm49gi0jvs95yneQ2Yrg@mail.gmail.com>
	<alpine.LNX.2.00.1107311300190.16802@linux>
	<CACqU3MX=MVd8v2wKaFsNuXB2WsWq2jLsGfAdDEW9atoWbWE7Mg@mail.gmail.com>
	<alpine.LNX.2.00.1107311333320.53256@linux>
	<CACqU3MWHRJXRu5sOvyGhyiqV94=UmDfCxixf-okkGuphxUFRTQ@mail.gmail.com>
	<alpine.LNX.2.00.1107311437460.28279@linux>
	<CACqU3MVSH9HKdKFpw1dxKRHV1grPEMjnNbrAbE73yLrZbgYHcg@mail.gmail.com>
Date: Mon, 29 Aug 2011 20:27:23 -0400
Message-ID: <CACqU3MXC=rXu8NtO+uBMuzbPAtJzwuR1tkKyWA61-FhE2cxh_A@mail.gmail.com>
Subject: Re: [PATCH v2] kbuild: prevent make from deleting _shipped files
From: Arnaud Lacombe <lacombar@gmail.com>
To: mmarek@suse.cz
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>,
        Peter Foley <pefoley2@verizon.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jul 31, 2011 at 3:03 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Hi,
>
> On Sun, Jul 31, 2011 at 2:45 PM, Peter Foley <pefoley2@verizon.net> wrote:
>> commit 7373f4f (kbuild: add implicit rules for parser generation)
>> created a implicit rule chain (%.c: %.c_shipped: %.y).
>> Make considers the _shipped files to be intermediate files which
>> causes them to be deleted if they didn't exist before make was run.
>> Mark the _shipped files PRECIOUS to prevent make from deleting them.
>>
>> Signed-off-by: Peter Foley <pefoley2@verizon.net>
>
> Acked-by: Arnaud Lacombe <lacombar@gmail.com>
>
ping, Michal ?

 - Arnaud

>  - Arnaud
>
>> ---
>>
>> V2: update changelog to specify files are only deleted when they did not
>> already exist
>>
>> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
>> index aeea84a..5d986d9 100644
>> --- a/scripts/Makefile.lib
>> +++ b/scripts/Makefile.lib
>> @@ -167,6 +167,7 @@ ifdef REGENERATE_PARSERS
>>  quiet_cmd_gperf = GPERF $@
>>       cmd_gperf = gperf -t --output-file $@ -a -C -E -g -k 1,3,$$ -p -t $<
>>
>> +.PRECIOUS: $(src)/%.hash.c_shipped
>>  $(src)/%.hash.c_shipped: $(src)/%.gperf
>>        $(call cmd,gperf)
>>
>> @@ -177,6 +178,7 @@ LEX_PREFIX = $(if $(LEX_PREFIX_${baseprereq}),$(LEX_PREFIX_${baseprereq}),yy)
>>  quiet_cmd_flex = LEX     $@
>>       cmd_flex = flex -o$@ -L -P $(LEX_PREFIX) $<
>>
>> +.PRECIOUS: $(src)/%.lex.c_shipped
>>  $(src)/%.lex.c_shipped: $(src)/%.l
>>        $(call cmd,flex)
>>
>> @@ -187,12 +189,14 @@ YACC_PREFIX = $(if $(YACC_PREFIX_${baseprereq}),$(YACC_PREFIX_${baseprereq}),yy)
>>  quiet_cmd_bison = YACC    $@
>>       cmd_bison = bison -o$@ -t -l -p $(YACC_PREFIX) $<
>>
>> +.PRECIOUS: $(src)/%.tab.c_shipped
>>  $(src)/%.tab.c_shipped: $(src)/%.y
>>        $(call cmd,bison)
>>
>>  quiet_cmd_bison_h = YACC    $@
>>       cmd_bison_h = bison -o/dev/null --defines=$@ -t -l -p $(YACC_PREFIX) $<
>>
>> +.PRECIOUS: $(src)/%.tab.h_shipped
>>  $(src)/%.tab.h_shipped: $(src)/%.y
>>        $(call cmd,bison_h)
>>
>>
>>
>
