Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174Ab0JRTji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:39:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58794 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933145Ab0JRTjg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:39:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=fjL1mDncDO6EABHOe3unIX8KRdNewVowBUpcxzmOxSSxiSmKV5wAZNhjmYkXpNRlBc
         Kl+r54p55iUiVxSoqsHd9wPhDG0UxafnlQWqWwtjktzDJJZ1B88GWdZG2yrXMMOPEMi8
         DaAUf3PHxFa/Uh6Dohdu/9wh2gz66dhW9V6ms=
MIME-Version: 1.0
In-Reply-To: <20101018191209.GE2468@vigoh>
References: <1287268187-9628-1-git-send-email-vapier@gentoo.org>
 <AANLkTinMSbhTkH0zQn_YO7hFF7zkuv-Gj-B0BUFWy5nP@mail.gmail.com>
 <20101018163223.GC2468@vigoh> <AANLkTin3Tx8jyR47G3SNbP_zFJ+tGdR6FtraHmM2T79j@mail.gmail.com>
 <20101018191209.GE2468@vigoh>
From: Mike Frysinger <vapier@gentoo.org>
Date: Mon, 18 Oct 2010 15:39:11 -0400
X-Google-Sender-Auth: Dkqa5Fmj-DVogpS4VhMxOe9SgWE
Message-ID: <AANLkTi=w8sHhyqSwWjQzosCUJA-5MzjTQwp6oPccNpnY@mail.gmail.com>
Subject: Re: [PATCH] bluetooth: fix unaligned access to l2cap conf data
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
        linux-bluetooth@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        steven miao <realmz6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 15:12, Gustavo F. Padovan wrote:
> * Mike Frysinger <vapier@gentoo.org> [2010-10-18 15:10:36 -0400]:
>> On Mon, Oct 18, 2010 at 12:32, Gustavo F. Padovan wrote:
>> > * Harvey Harrison <harvey.harrison@gmail.com> [2010-10-18 11:17:28 -0700]:
>> >> On Sat, Oct 16, 2010 at 3:29 PM, Mike Frysinger <vapier@gentoo.org> wrote:
>> >> > From: steven miao <realmz6@gmail.com>
>> >> >
>> >> >        case 2:
>> >> > -               *((__le16 *) opt->val) = cpu_to_le16(val);
>> >> > +               put_unaligned_le16(cpu_to_le16(val), opt->val);
>> >> >                break;
>> >>
>> >> I think you wanted:
>> >> put_unaligned_le16(val, opt->val);
>> >
>> > I fixed that in the tree. Thanks for the report.
>>
>> i guess you fixed the 32bit one too ?
>>   put_unaligned_le32(cpu_to_le32(val), opt->val);
>
> Yes, I did.

cool.  thanks guys !
-mike
