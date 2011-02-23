Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab1BWWRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 17:17:37 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51781 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab1BWWRf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 17:17:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=iwMMVFYDhk6huFQ9YQS9ZfWizHBKDM2++9Bp26vjPZjMGAr9VN9GRsEU5LqZ1ZiSUw
         YBBxobf7iW+r3wRXRcGlZ37PwSjR0ETywIc7v03FmQdMr/cGNK4hTLpD5wjOLFel8LiT
         wj294ijDEHt2h10/4gSfJIg9yXHeVPxf2QeLw=
MIME-Version: 1.0
In-Reply-To: <20110223210326.GB27738@atj.dyndns.org>
References: <20110223171945.GI26065@htj.dyndns.org>
	<4D656D1A.7030006@kernel.org>
	<20110223204656.GA27738@atj.dyndns.org>
	<4D657359.5060901@kernel.org>
	<20110223210326.GB27738@atj.dyndns.org>
Date: Wed, 23 Feb 2011 14:17:34 -0800
X-Google-Sender-Auth: KKP2UE69mtlgopQO9MmmSEf2CkE
Message-ID: <AANLkTintYZ00-MZD5hv7p0zNeDJTyyzdR-C=7qWo78Ly@mail.gmail.com>
Subject: Re: questions about init_memory_mapping_high()
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 1:03 PM, Tejun Heo <tj@kernel.org> wrote:
>> > Yeah, sure, my point was that not mapping those holes is likely to be
>> > worse.  Wouldn't it be better to get low and high ends of the occupied
>> > area and expand those to larger mapping size?  It's worse to match the
>> > memory map exactly.  You unnecessarily end up with smaller mappings.
>>
>> it will reuse previous not used entries in the init_memory_mapping().
>
> Hmmm... I'm not really following.  Can you elaborate?  The reason why
> smaller mapping is bad is because of increased TLB pressure.  What
> does using the existing entries have to do with it?

assume 1g page is used. first node will actually mapped 512G already.
so if the system only have 1024g. then first 512g page table will on node0 ram.
second 512g page table will be on node4.

when only 2M are used, it is 1G boundary. for 1024g system.
page table (about 512k) for mem 0-128g is on node0.
page table (about 512k) for mem 128g-256g is on node1.
...
Do you mean we need to put those all 512k together to reduce TLB presure?

Yinghai
