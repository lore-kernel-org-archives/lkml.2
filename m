Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab1DFWKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 18:10:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45518 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756369Ab1DFWKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 18:10:19 -0400
Message-ID: <4D9CE4AE.4090303@zytor.com>
Date: Wed, 06 Apr 2011 15:09:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: tip: New "Link:" tag to replace "LKML-Reference:"
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

At Linus' request, I have modified the tip-bot to recognize a new form
of email archive references, which should work as clickable links.
Instead of:

LKML-Reference: <message-id>

use, instead:

Link: http://lkml.kernel.org/r/message-id

The entire bit "Link: http://lkml.kernel.org/r/" is a literal; the rest
is the message-id from the original message, *without* angle brackets.
This points to a redirection service on kernel.org, which currently
bounces to marc.info, but which we can redirect in the future.

I changed the name from LKML-Reference: to Link: to make the width of
the string tolerable, and since the link itself contains an explicit
reference to the specific archive used.

Please note that message-ids sometimes contain characters which have to
be escaped to fit in valid URI syntax!  The characters @ and $ which are
very common in message-ids do not, however, need to be escaped in this
particular context (even though they are not part of the URI safe
character set, and so most library functions will escape them.)  The
characters # ; & % as well as whitespace are definitely unsafe either
for use in an URI or for programs to recognize them as part of one, and
should definitely be escaped.

The tip-bot will recognize the *exact* form above (including URI
escaping) and should do the message threading correctly.  To keep people
from injecting malicious links, however, there is sanity filtering on
the unescaped content, so in theory a legal-but-weird message-id might
be rejected.

	-hpa

