Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889Ab0JSVPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 17:15:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53559 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757850Ab0JSVPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 17:15:40 -0400
Message-ID: <4CBE0A34.4060002@zytor.com>
Date: Tue, 19 Oct 2010 14:14:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, akpm@linux-foundation.org,
        heukelum@fastmail.fm, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix CFI macro invocations to deal with	 shortcomings
 in gas
References: <4CBDBEBA020000780001E05A@vpn.id2.novell.com>
In-Reply-To: <4CBDBEBA020000780001E05A@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2010 06:52 AM, Jan Beulich wrote:
> gas prior to (perhaps) 2.16.90 has problems with passing non-
> parenthesized expressions containing spaces to macros. Spaces, however,
> get inserted by cpp between any macro expanding to a number and a
> subsequent + or -. For the +, current x86 gas then removes the space
> again (future gas may not do so), but for the - the space gets retained
> and is then considered a separator between macro arguments.
> 
> Fix the respective definitions for both the - and + cases, so that they
> neither contain spaces nor make cpp insert any (the latter by adding
> seemingly redundant parentheses).
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Alexander van Heukelum <heukelum@fastmail.fm>
> 

It's ugly -- very ugly -- and will almost certainly bitrot and break
again, but it's a lot less ugly than any other alternative I can think
of.  Unfortunately these versions of gas are not old enough that we can
just kill them off, I don't think.

	-hpa
