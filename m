Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab1A3Qpe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 11:45:34 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53293 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab1A3Qpd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 11:45:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uYqo9WGOaSlhKsju82y//Z3uSs8P6rAmp3afgtOmcAnBD1MQgSf85JuRUxqoj2TwEY
         crw3ozYK6WmpIfgORIEwUeObixigO2Pe/MRJq7tRoyOqeSQHAOB2oRVX1t0rsKOQlpn6
         SGv8m/5p97JEYr8JmJX4yrK7fdT0r88MIZPg8=
MIME-Version: 1.0
In-Reply-To: <4D456FF9.2010309@redhat.com>
References: <1296244340-15173-1-git-send-email-glommer@redhat.com>
	<1296244340-15173-4-git-send-email-glommer@redhat.com>
	<4D456FF9.2010309@redhat.com>
Date: Mon, 31 Jan 2011 00:45:32 +0800
Message-ID: <AANLkTi=-y7fk1HwiH8+_fSxbp_rif+MRzuhcNmwc38_V@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] KVM-GST: KVM Steal time accounting
From: lidong chen <chen.lidong.kernel@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think we can use performance counter.
use unhalted core cycles event, in the nmi callback funcation, count
which process is running .
if the vm exit is caused by nmi,discard it.
the system time of qemu process is the time steal by kvm.



2011/1/30 Avi Kivity <avi@redhat.com>:
> On 01/28/2011 09:52 PM, Glauber Costa wrote:
>>
>> This patch accounts steal time time in kernel/sched.
>> I kept it from last proposal, because I still see advantages
>> in it: Doing it here will give us easier access from scheduler
>> variables such as the cpu rq. The next patch shows an example of
>> usage for it.
>>
>> Since functions like account_idle_time() can be called from
>> multiple places, not only account_process_tick(), steal time
>> grabbing is repeated in each account function separatedely.
>>
>
> I accept that steal time is worthwhile, but do you have some way to
> demonstrate that the implementation actually works and is beneficial?
>
> Perhaps run two cpu-bound compute processes on one vcpu, overcommit that
> vcpu, and see what happens to the processing rate with and without steal
> time accounting.  I'd expect a fairer response with steal time accounting.
>
> --
> error compiling committee.c: too many arguments to function
>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
