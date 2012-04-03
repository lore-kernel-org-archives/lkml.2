Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab2DCS1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 14:27:24 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:39388 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab2DCS1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 14:27:23 -0400
Message-ID: <4F7B4109.9030008@tilera.com>
Date: Tue, 3 Apr 2012 14:27:21 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Kautuk Consul <consul.kautuk@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: CodingStyle vs checkpatch for block comments
References: <1333195539-5421-1-git-send-email-consul.kautuk@gmail.com>  <4F7B2114.4000806@tilera.com>  <CAFPAmTTfYKT39gdoKT3P4G2O0xkTSS8g62kKudeLcnpdipzJqg@mail.gmail.com>  <4F7B21FB.3040609@tilera.com>  <CAFPAmTS_2H7BzGndcceBxdnJroy82u++sduCPO2+qxG6-WA=nw@mail.gmail.com>  <4F7B2766.9080208@tilera.com> <1333471474.26079.43.camel@joe2Laptop>  <4F7B2AA7.5010906@tilera.com> <1333472391.26079.47.camel@joe2Laptop>  <4F7B32A0.1020009@tilera.com> <1333474907.26079.57.camel@joe2Laptop>  <4F7B3C8B.9010609@tilera.com> <1333477010.26079.65.camel@joe2Laptop>
In-Reply-To: <1333477010.26079.65.camel@joe2Laptop>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 4/3/2012 2:16 PM, Joe Perches wrote:
> On Tue, 2012-04-03 at 14:08 -0400, Chris Metcalf wrote:
>> On 4/3/2012 1:41 PM, Joe Perches wrote:
>>> On Tue, 2012-04-03 at 13:25 -0400, Chris Metcalf wrote:
>>>> The relevant code in checkpatch.pl is:
>>>>
>>>>                 if ($rawline =~ /^\+[ \t]*\/\*[ \t]*$/ &&
>>>>                     $prevrawline =~ /^\+[ \t]*$/) {
>>>>                         CHK("BLOCK_COMMENT_STYLE",
>>>>                             "Don't begin block comments with only a /*
>>>> line, use /* comment...\n" . $hereprev);
>>>>                 }
>>>>
>>>> So, my questions -
>>>>
>>>> 1. I'm not sure what the regexps are really trying to avoid.  Presumably a
>>>> blank line followed by a block comment is OK?  Certainly the kernel sources
>>>> are full of this construct.
>>> It emits a check message on
>>> <blank line>
>>> 	/*
>>>
>>> but not
>>> <blank line>
>>> 	/* some actual comment
>> Right, I understand what the regexps do, I'm just not clear on what the
>> rationale is.
> Fewer vertical lines for block comments.
>
> This block comment uses a lot of lines:
>
> 		some_code();
> 	}
>
> 	/*
> 	 * Some multiline
> 	 * block comment
> 	 */
>
> 	some_more_code();
>
> This is 1 fewer line
>
> 		some_code();
> 	}
>
> 	/* Some multline
> 	 * block comment
> 	 */
>
> 	some_more_code();
>
> [....]
> It's suggesting that a multi line comment block
> starting with only a /* wastes space on vertically
> challenged terminals.

So I suggest we drop the check from checkpatch, then, since it appears to
conflict with Documentation/CodingStyle.
-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

