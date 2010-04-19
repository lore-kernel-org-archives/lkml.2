Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab0DSTKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 15:10:32 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:25922 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab0DSTKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 15:10:31 -0400
Message-ID: <4BCCAA5D.1000809@oracle.com>
Date: Mon, 19 Apr 2010 12:09:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: John Kacur <jkacur@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: trace-cmd: make Makefile rpm-friendly
References: <20100419100058.6f1457dd.randy.dunlap@oracle.com>	 <alpine.LFD.2.00.1004191942010.4111@localhost.localdomain> <1271703972.10448.5.camel@gandalf.stny.rr.com>
In-Reply-To: <1271703972.10448.5.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090205.4BCCAA98.01A6:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/10 12:06, Steven Rostedt wrote:
> On Mon, 2010-04-19 at 20:11 +0200, John Kacur wrote:
>>
>> On Mon, 19 Apr 2010, Randy Dunlap wrote:
>>
>>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>>
>>> Update Makefile to support rpmbuild DESTDIR usage.
>>
>> So, what would happen if you did
>> make DESTDIR=/usr/local install ?
>>
>> I think you would get /usr/local/usr/local
>> So, I think I would NAK this patch.
>>
>> I also don't believe there is anything magical about DESTDIR in a spec 
>> file. Essentially, prefix in this makefile is equivalent to DESTDIR, so 
>> you can replace DESTDIR with prefix in a spec template.
>>  
> 
> NAK is too strong. I was looking at what perf does, and it basically
> makes prefix and DESTDIR the same.
> 
> ifndef DESTDIR
> prefix = $(HOME)
> endif
> 
> We could do..
> 
> ifndef DESDIR
> prefix = /usr/local/bin
> endif
> 
> and then, if DESTDIR is not set, it would do the right thing.

Yes, thanks, but I have it "fixed" now (for some daffynition of fixed).

-- 
~Randy
