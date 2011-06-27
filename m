Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab1F0Xhm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 19:37:42 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40652 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461Ab1F0XgK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 19:36:10 -0400
MIME-Version: 1.0
In-Reply-To: <20110627232903.GB7736@n2100.arm.linux.org.uk>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
 <1308640714-17961-2-git-send-email-ohad@wizery.com> <20110627204958.GB20865@ponder.secretlab.ca>
 <20110627232903.GB7736@n2100.arm.linux.org.uk>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 27 Jun 2011 17:35:49 -0600
X-Google-Sender-Auth: 1-Lcwx9Yk3mwrJnSeuFQcNgh2zA
Message-ID: <BANLkTi=MDSuiGb64Se1T7zCWG6syxXbhTg@mail.gmail.com>
Subject: Re: [RFC 1/8] drivers: add generic remoteproc framework
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Ohad Ben-Cohen <ohad@wizery.com>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Arnd Bergmann <arnd@arndb.de>, Brian Swetland <swetland@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 5:29 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Jun 27, 2011 at 02:49:58PM -0600, Grant Likely wrote:
>> > +struct {
>> > +      char magic[4] = { 'R', 'P', 'R', 'C' };
>> > +      u32 version;
>> > +      u32 header_len;
>> > +      char header[...] = { header_len bytes of unformatted, textual header };
>> > +      struct section {
>> > +          u32 type;
>> > +          u64 da;
>> > +          u32 len;
>> > +          u8 content[...] = { len bytes of binary data };
>> > +      } [ no limit on number of sections ];
>> > +} __packed;
>>
>> Other have commented on the image format, so I'll skip this bit other
>> than saying that I agree it would be great to have a common format.
>
> (Don't have the original message to reply to...)
>
> Do we really want to end up with header being 5 bytes, header_len set
> as 5, and having to load/store all this data using byte loads/stores ?
>
> If we don't want that, then I suggest we get rid of the packed attribute,
> and require stuff to be naturally aligned.
>
> First issue is that struct section could be much better layed out:
>
> struct section {
>        u32 type;
>        u32 len;
>        u64 da;
>        u8 content[];
> };
>
> and require sizeof(struct section) % sizeof(u64) == 0 - iow, to find
> the next section, round len up to sizeof(u64).  Ditto for the header.

Hopefully this will all be moot since it has been proposed to use elf
images directly.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
