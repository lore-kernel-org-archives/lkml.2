Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290Ab0GHBmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 21:42:10 -0400
Received: from tpa-qmail.dyxnet.com ([152.104.96.30]:57870 "HELO
	tpa-qmailr1.dyxnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758082Ab0GHBmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 21:42:08 -0400
X-DYX-POP3-Checked-Auth: 192.168.131.61:kernel@takeo.idv.tw
Message-ID: <3CEC7CEBD755411B9547FE08565197B2@TAKEOW7NB1>
From: "Takeo Tung" <kernel@takeo.idv.tw>
To: "Neil Brown" <neilb@suse.de>
Cc: "Christoph Hellwig" <hch@lst.de>, "Michal Marek" <mmarek@suse.cz>,
       <linux-kernel@vger.kernel.org>, <viro@zeniv.linux.org.uk>,
       <sfr@canb.auug.org.au>
References: <10E8B8D94205471F942B06D2A007832D@TAKEOW7NB1><4C129778.7040409@suse.cz><F8C0125B8F424A279E9679EAC24AC983@TAKEOW7NB1><20100612094937.GA12455@lst.de><F2CA952B7B5A41259C5F950CA3454C3A@TAKEOW7NB1><1AEF19B8648844C983F583EEBE9C46F4@TAKEOW7NB1><20100707231732.GA30007@lst.de><20100708094851.6dc6199d@notabene.brown><F0921DE61714438C86A1AB46A4E7F22D@TAKEOW7NB1> <20100708111536.6068ca58@notabene.brown>
In-Reply-To: <20100708111536.6068ca58@notabene.brown>
Subject: Re: [PATCH] struct io panic on raid1 - Re: block: unify flags for struct bio and struct request will kernel panic
Date: Thu, 8 Jul 2010 09:42:04 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8089.726
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8089.726
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Neil,

Ok. bcoz I don't sure you like define is 'bool' or 'unsigned long', if using 
'unsigned long', I no problem now. sorry for my poor english.

Thanks,
Takeo Tung

--------------------------------------------------
From: "Neil Brown" <neilb@suse.de>
Sent: Thursday, July 08, 2010 9:15 AM
To: "Takeo Tung" <kernel@takeo.idv.tw>
Cc: "Christoph Hellwig" <hch@lst.de>; "Michal Marek" <mmarek@suse.cz>; 
<linux-kernel@vger.kernel.org>; <viro@zeniv.linux.org.uk>; 
<sfr@canb.auug.org.au>
Subject: Re: [PATCH] struct io panic on raid1 - Re: block: unify flags for 
struct bio and struct request will kernel panic

> On Thu, 8 Jul 2010 08:43:38 +0800
> "Takeo Tung" <kernel@takeo.idv.tw> wrote:
>
>> Hello,
>>
>> ok. I rewrite the patch back to bool and re-add bio_rw_flagged fucntion. 
>> pls
>> review it and any comment?
>
> I'm not sure why you did that.
> I meant to say that I liked the fact that you had changed from 'bool' to
> 'unsigned long' and that I thought using 'bool' was unnecessary.  Maybe I
> didn't say that very clearly.
>
> It doesn't matter to me particularly which approach is used, but please 
> don't
> re-introduce bio_rw_flagged because you think I want it - I don't.
>
> Thanks,
> NeilBrown
>
>>
>> Thanks,
>> Takeo Tung
>>
>> --------------------------------------------------
>> From: "Neil Brown" <neilb@suse.de>
>> Sent: Thursday, July 08, 2010 7:48 AM
>> To: "Christoph Hellwig" <hch@lst.de>
>> Cc: "Takeo Tung" <kernel@takeo.idv.tw>; "Michal Marek" <mmarek@suse.cz>;
>> <linux-kernel@vger.kernel.org>; <viro@zeniv.linux.org.uk>;
>> <sfr@canb.auug.org.au>
>> Subject: Re: [PATCH] struct io panic on raid1 - Re: block: unify flags 
>> for
>> struct bio and struct request will kernel panic
>>
>> > On Thu, 8 Jul 2010 01:17:32 +0200
>> > Christoph Hellwig <hch@lst.de> wrote:
>> >
>> >> On Thu, Jul 08, 2010 at 07:05:39AM +0800, Takeo Tung wrote:
>> >> > Dear Christoph,
>> >> >
>> >> > I was check the patch again. I found the panic status haapen on Soft
>> >> > RAID
>> >> > 1. I review it. found some define using bool, so some like ( x &
>> >> > REQ_SYNC)
>> >> > only 0 or 1.
>> >> > so if bi_rw = rw | sync will bi_rw = rw | 0 or rw | 1. not rw | ( 1 
>> >> > <<
>> >> > __REQ_SYNC).
>> >> >
>> >> > So I write a patch is fix it. seems normal now. could you review the
>> >> > patch
>> >> > or any comment?
>> >>
>> >> The patch looks correct to me, although your mailer mangled the
>> >> whitespace badly.  If Neil wants to keep the flag as bool we could
>> >> also add a !! around the bit flag checks.
>> >
>> > I think it is best to make them "unsigned long" holding the actual but.
>> > They were only made 'bool' because that is was bio_rw_flagged() 
>> > returned.
>> > Converting to a bool then back to a bit-flag is unnecessary.
>> >
>> > Thanks,
>> > NeilBrown
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" 
>> > in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > Please read the FAQ at  http://www.tux.org/lkml/
>> >
>> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
> 
