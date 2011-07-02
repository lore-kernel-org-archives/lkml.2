Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab1GBRX1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 13:23:27 -0400
Received: from mail.lang.hm ([64.81.33.126]:39431 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303Ab1GBRX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 13:23:26 -0400
Date: Sat, 2 Jul 2011 10:23:23 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
cc: linux-kernel-mail <linux-kernel@vger.kernel.org>,
        linux-newbie@vger.kernel.org
Subject: Re: Question on syslogd and syslog
In-Reply-To: <BANLkTi=tFc2uoGMNFAAFqpeka_otC6CsOQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1107021021090.26801@asgard.lang.hm>
References: <BANLkTin_Yo+wnwWyMFoG3Nv5SSzJj8J1_w@mail.gmail.com> <alpine.DEB.2.02.1106281238210.7935@asgard.lang.hm> <BANLkTi=tFc2uoGMNFAAFqpeka_otC6CsOQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="680960-1374684458-1309627403=:26801"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--680960-1374684458-1309627403=:26801
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

the problem is that in the syslog spec, the facility and severity get 
combined into one 8 bit field (one of the two only has 12 values defined 
instead of 16, but I don't remember off the top of my head which one)

so extending this is creating a new protocol.

also, the reason I was talking about filtering is that other than 
filtering, what purpose is there in settng the facility?

David Lang

On Sat, 2 Jul 2011, Sri Ram Vemulpali wrote:

> Thanks for the replies. My question is more on how to extend
> facilities, rather on how to filter the messages. It seems there is a
> code in the toolchain syslog.h where the array representing the
> facilities needs to be extended. Please correct me if I am wrong.
>
> Sri.
>
> On Tue, Jun 28, 2011 at 3:41 PM,  <david@lang.hm> wrote:
>> you would be creating a completely different over-the-wire protocol for your
>> syslog messages.
>>
>> however, note that newer syslog daemons (syslog-ng and rsyslog for example)
>> allow you to do filtering on just about anything in the message, not just
>> the facility and severity.
>>
>> David Lang
>>
>> On Tue, 28 Jun 2011, Sri Ram Vemulpali wrote:
>>
>>> Date: Tue, 28 Jun 2011 14:11:59 -0400
>>> From: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
>>> To: linux-kernel-mail <linux-kernel@vger.kernel.org>,
>>>    linux-newbie@vger.kernel.org
>>> Subject: Question on syslogd and syslog
>>>
>>> Hello All,
>>>
>>>   I am looking to modify number of facilities available in syslog so
>>> that for my application I can have much more array of them at disposal
>>> of my need. So currently only LOG_LOCAL0 - LOG_LOCAL7 are defined for
>>> user, what if I want to extend them, is there a way I can extend them.
>>> Or should I go ahead and modify the source code of syslog. Can any
>>> please point me in right direction and where can I get syslogd and
>>> syslog source code. Thanks in advance.
>>>
>>>
>>
>
>
>
>
--680960-1374684458-1309627403=:26801--
