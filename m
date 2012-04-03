Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab2DCRZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 13:25:55 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:64692 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232Ab2DCRZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 13:25:54 -0400
Message-ID: <4F7B32A0.1020009@tilera.com>
Date: Tue, 3 Apr 2012 13:25:52 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Kautuk Consul <consul.kautuk@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: CodingStyle vs checkpatch for block comments
References: <1333195539-5421-1-git-send-email-consul.kautuk@gmail.com>  <4F7B2114.4000806@tilera.com>  <CAFPAmTTfYKT39gdoKT3P4G2O0xkTSS8g62kKudeLcnpdipzJqg@mail.gmail.com>  <4F7B21FB.3040609@tilera.com>  <CAFPAmTS_2H7BzGndcceBxdnJroy82u++sduCPO2+qxG6-WA=nw@mail.gmail.com>  <4F7B2766.9080208@tilera.com> <1333471474.26079.43.camel@joe2Laptop>  <4F7B2AA7.5010906@tilera.com> <1333472391.26079.47.camel@joe2Laptop>
In-Reply-To: <1333472391.26079.47.camel@joe2Laptop>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding linux-kernel to the cc's and restating the question...)

I accepted a patch from Kautuk Consul and adjusted his comment style, but
he pointed out that he had changed his comment style based on a warning
from checkpatch.

The Documentation/CodingStyle file says:

    The preferred style for long (multi-line) comments is:

       /*
        * This is the preferred style for multi-line
        * comments in the Linux kernel source code.
        * Please use it consistently.
        *
        * Description:  A column of asterisks on the left side,
        * with beginning and ending almost-blank lines.
        */

However, a new change to "checkpatch --strict" by Joe Perches, commit
aad4f61498, causes this construct to be flagged as a warning if (and only
if) it is preceded by a blank line.  Joe said the change was to support
David Miller's preferred style, but that he didn't much care one way or
another.

The relevant code in checkpatch.pl is:

                if ($rawline =~ /^\+[ \t]*\/\*[ \t]*$/ &&
                    $prevrawline =~ /^\+[ \t]*$/) {
                        CHK("BLOCK_COMMENT_STYLE",
                            "Don't begin block comments with only a /*
line, use /* comment...\n" . $hereprev);
                }

So, my questions -

1. I'm not sure what the regexps are really trying to avoid.  Presumably a
blank line followed by a block comment is OK?  Certainly the kernel sources
are full of this construct.

2. The actual warning message emitted seems to directly contradict the
CodingStyle document, so presumably we should either clarify the message,
or update CodingStyle if we're really trying to change the style.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

