Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab1DGOIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 10:08:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:35754 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab1DGOIr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 10:08:47 -0400
Subject: Re: tip: New "Link:" tag to replace "LKML-Reference:"
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4D9CE4AE.4090303@zytor.com>
References: <4D9CE4AE.4090303@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 07 Apr 2011 16:08:32 +0200
Message-ID: <1302185312.3329.1240.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-06 at 15:09 -0700, H. Peter Anvin wrote:
> Hi all,
> 
> At Linus' request, I have modified the tip-bot to recognize a new form
> of email archive references, which should work as clickable links.
> Instead of:
> 
> LKML-Reference: <message-id>
> 
> use, instead:
> 
> Link: http://lkml.kernel.org/r/message-id
> 
> The entire bit "Link: http://lkml.kernel.org/r/" is a literal; the rest
> is the message-id from the original message, *without* angle brackets.
> This points to a redirection service on kernel.org, which currently
> bounces to marc.info, but which we can redirect in the future.
> 
> I changed the name from LKML-Reference: to Link: to make the width of
> the string tolerable, and since the link itself contains an explicit
> reference to the specific archive used.
> 
> Please note that message-ids sometimes contain characters which have to
> be escaped to fit in valid URI syntax!  The characters @ and $ which are
> very common in message-ids do not, however, need to be escaped in this
> particular context (even though they are not part of the URI safe
> character set, and so most library functions will escape them.)  The
> characters # ; & % as well as whitespace are definitely unsafe either
> for use in an URI or for programs to recognize them as part of one, and
> should definitely be escaped.
> 
> The tip-bot will recognize the *exact* form above (including URI
> escaping) and should do the message threading correctly.  To keep people
> from injecting malicious links, however, there is sanity filtering on
> the unescaped content, so in theory a legal-but-weird message-id might
> be rejected.

OK, so I fixed my scripts to match this and it all seems to work, except
for the:

 LKML-Reference: <new-submission>

case, where the tip-bot would mail it out for me. While I try not to use
it too much its convenient for quick fixes etc. Will the absence of a
Link tag suffice or is there more to it?
