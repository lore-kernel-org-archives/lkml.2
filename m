Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab0HSQSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 12:18:53 -0400
Received: from lo.gmane.org ([80.91.229.12]:37727 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753025Ab0HSQSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 12:18:51 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Subject: Re: [RFC][PATCH] introduce ptr_diff()
Date: Thu, 19 Aug 2010 17:18:42 +0100
Message-ID: <yw1xaaoi8tjx.fsf@unicorn.mansr.com>
References: <1282217856-8625-1-git-send-email-namhyung@gmail.com> <5790.1282219392@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: unicorn.mansr.com
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (garbanzo, linux)
Cancel-Lock: sha1:T+b1Ub/4wedq823jw3n2lJ6aVmE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> Namhyung Kim <namhyung@gmail.com> wrote:
>
>> +	if (is_power_of_2(__size))				\
>> +		__diff = (__addr1 - __addr2) >> ilog2(__size);	\
>> +	else							\
>> +		__diff = (__addr1 - __addr2) / __size;		\
>
> You shouldn't need to do this.  The compiler's optimiser should switch a
> divide to a shift for a power-of-2 divisor.

Only when the numerator is provably non-negative, which is certainly
not the case here.

-- 
Måns Rullgård
mans@mansr.com

