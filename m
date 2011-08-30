Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab1H3WAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 18:00:06 -0400
Received: from lo.gmane.org ([80.91.229.12]:58853 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924Ab1H3WAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 18:00:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Subject: Re: [patch 03/36] Hexagon: Add bitops support
Date: Tue, 30 Aug 2011 22:59:46 +0100
Message-ID: <yw1xbov6h86l.fsf@unicorn.mansr.com>
References: <20110817163457.878854582@codeaurora.org>
	<20110817163520.145693358@codeaurora.org>
	<20110826203410.GB6630@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: unicorn.mansr.com
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Cancel-Lock: sha1:svvBMGG/Gb5iUVazZoLd4AWfN00=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

> Hi!
>
>> +	__asm__ __volatile__ (
>> +	"	{R10 = %1; R11 = asr(%2,#5); }\n"
>> +	"	{R10 += asl(R11,#2); R11 = and(%2,#0x1f)}\n"
>> +	"1:	R12 = memw_locked(R10);\n"
>> +	"	{ P0 = tstbit(R12,R11); R12 = clrbit(R12,R11); }\n"
>> +	"	memw_locked(R10,P1) = R12;\n"
>> +	"	{if !P1 jump 1b; %0 = mux(P0,#1,#0);}\n"
>
> Nice assembly syntax, btw. I can only wish architectures such as arm
> used something as readable...

The Blackfin syntax looks similar.  Now you may call me old-fashioned if
you want, but I personally find traditional assembler syntax much easier
to work with.

-- 
Måns Rullgård
mans@mansr.com

