Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab1GZRiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 13:38:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51539 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443Ab1GZRiM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 13:38:12 -0400
Subject: Re: [patch v2] x86: kvm: x86: fix information leak to userland
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4E2EF851.8060202@redhat.com>
Date: Tue, 26 Jul 2011 19:38:10 +0200
Cc: Vasiliy Kulikov <segooon@gmail.com>, Jan Kiszka <jan.kiszka@web.de>,
        kernel-janitors@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <F7E17FF1-9EF5-46F5-8B3A-8F3050912000@suse.de>
References: <1288447871-7715-1-git-send-email-segooon@gmail.com> <4CCC2D11.7090109@web.de> <20101030153147.GA14169@albatros> <4CCC3DC2.6090505@web.de> <20101030185447.GA7629@albatros> <ABD7343A-6440-4CC0-B8B0-9D27EF0291B0@suse.de> <4E2EF851.8060202@redhat.com>
To: Avi Kivity <avi@redhat.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 26.07.2011, at 19:24, Avi Kivity wrote:

> On 07/26/2011 08:05 PM, Alexander Graf wrote:
>> struct kvm_pit_state2 {
>>         struct kvm_pit_channel_state channels[3];
>>         __u32 flags;
>>         __u32 reserved[9];
>> };
>> 
>> So memset(&ps->reserved) would give you the a __u32 **, no? Same goes for all the other array sets in here. Or am I understanding some C logic wrong? :)
>> 
> 
> An address of an array is the array itself.

Ah, nice. So it's really a matter of taste then rather than functionality. Good to know :)


Alex

