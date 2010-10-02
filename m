Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab0JBGPZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 02:15:25 -0400
Received: from in.cluded.net ([195.159.98.120]:36225 "EHLO in.cluded.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423Ab0JBGPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 02:15:24 -0400
Message-ID: <4CA6CD79.80804@uw.no>
Date: Sat, 02 Oct 2010 06:13:13 +0000
From: "Daniel K." <dk@uw.no>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9a1) Gecko/20060307 SeaMonkey/1.5a
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH RESEND v3 09/24] ptrace: cleanup arch_ptrace() on frv
References: <1285838880-4977-1-git-send-email-namhyung@gmail.com>	 <1285838880-4977-10-git-send-email-namhyung@gmail.com>	 <4CA6A484.8000109@uw.no>  <1285991879.1696.4.camel@leonhard> <1285995551.1696.19.camel@leonhard>
In-Reply-To: <1285995551.1696.19.camel@leonhard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namhyung Kim wrote:
> 2010-10-02 (토), 12:57 +0900, Namhyung Kim:
>> 2010-10-02 (토), 03:18 +0000, Daniel K.:
>>> Namhyung Kim wrote:
>>>>       case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
>>>>             ret = -EIO;
>>> -             if ((addr & 3) || addr < 0)
>>> +             if (addr & 3)
>>>                     break;
>>>
>>>> -		ret = 0;
>>>> -		switch (addr >> 2) {
>>>> +		switch (regno) {
>>>>  		case 0 ... PT__END - 1:
>>>> -			ret = put_reg(child, addr >> 2, data);
>>>> -			break;
>>>> -
>>>> -		default:
>>>> -			ret = -EIO;
>>>> +			ret = put_reg(child, regno, data);
>>>>  			break;
>>>>  		}
>>>>  		break;
>>> With this, you remove the default case, and no longer return -EIO in the
>>> cases of PT__END + n, as in the PTRACE_PEEKUSR section above.
>>>
>>> This is a change of behaviour as far as I can tell, and not just a cleanup.
> 
> It would not be a change of behaviour. Because 'ret' was initialized
> with -EIO and only changed in the switch case. So assignment before
> switch can be removed and then will return -EIO in default case.

You are right, I was thrown by the piles of needless code here.

In fact, the whole switch can now be replaced with:

	if (regno < PT__END)
		ret = put_reg(child, regno, data);

but it is perhaps better to use the switch-style, for symmetry with
the PTRACE_PEEKUSR case directly above it?


Sorry to cause alarm.


Daniel K.
