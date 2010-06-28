Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab0F1Tnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 15:43:31 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58939 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab0F1Tna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 15:43:30 -0400
To: Andi Kleen <andi@firstfloor.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nathan Fontenot <nfont@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
References: <87d3vfeage.fsf@basil.nowhere.org>
	<4C24C279.3050206@austin.ibm.com>
	<20100628110658.387B.A69D9226@jp.fujitsu.com>
	<m14ognkd26.fsf@fess.ebiederm.org>
	<20100628141615.GA7608@basil.fritz.box>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 28 Jun 2010 12:43:15 -0700
In-Reply-To: <20100628141615.GA7608@basil.fritz.box> (Andi Kleen's message of "Mon\, 28 Jun 2010 16\:16\:15 +0200")
Message-ID: <m1fx07c59o.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 0; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: ; sa07 0; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andi Kleen <andi@firstfloor.org>
X-Spam-Relay-Country: _RELAYCOUNTRY_
Subject: Re: [PATCH] memory hotplug disable boot option
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

>> I have a prototype patch sitting around somewhere.  I think ultimately
>> it makes sense to do something like extN's htree directory structure
>> in sysfs.  I wanted to get the tagged sysfs support in before I worked
>> on scalability because that slightly changes the requirements.
>> 
>> Improving the scalability here is certainly worth doing, but I am slightly
>> concerned there is something else algorithmically wrong if this is still
>> going to take 33 minutes to boot with 2TB.
>
> I'm don't think thousands of entries in sysfs is really a good idea. Even if you fix
> the the insert algorithm issues a simple ls will still be very slow and there
> will be likely other issues too. And nobody can claim that's a good interface.

Yes.  I am much more interested in fixing lookup and stat performance,
if people only look at insert performance it is a bit of a joke.

That said there are cases of people using a lot of network virtual
network devices that are essentially sane that push sysfs.

This is only the second or third time sysfs scalability has come up
this year.  So at some level I think it is sane to fix sysfs regardless
of what we do with memory hotplug.

Ensuring that our insert times are O(logN) for insert, O(N) for readdir,
O(logN) for lookup and O(log1) for stat, seems useful if we can do it
without other complications.

Eric
