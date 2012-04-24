Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab2DXA0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 20:26:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10346 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab2DXA0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 20:26:11 -0400
X-Authority-Analysis: v=2.0 cv=IaEFqBWa c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=3cFP2XwQnlkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=krVzvYWol8L9bVSQVugA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335227168.28106.126.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 03/11] parse-events: Get rid of handling concatenation
 on event_read_print
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 23 Apr 2012 20:26:08 -0400
In-Reply-To: <87pqayrnwg.fsf@sejong.aot.lge.com>
References: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
	 <1335157118-14658-4-git-send-email-namhyung.kim@lge.com>
	 <1335198822.28106.105.camel@gandalf.stny.rr.com>
	 <87pqayrnwg.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-24 at 09:09 +0900, Namhyung Kim wrote:
> Hi,
> 
> On Mon, 23 Apr 2012 12:33:42 -0400, Steven Rostedt wrote:
> > On Mon, 2012-04-23 at 13:58 +0900, Namhyung Kim wrote:
> >> The concatenation of subsequent DQUOTE'd strings is handled
> >> by __read_token() already.
> >> 
> >
> > You missed the point of this concat. It's not connecting "xxx" it is
> > connecting "xxx" "yyy" into "xxxyyy", as some events do this.
> >
> 
> I think I don't :). Please see commit 0f15820 ("parse-events:
> Concatinate two strings that are adjacent").

Heh, OK, I remember doing it for the print statement, but I guess I
needed to do it for the token too. As the commits for both are almost
identical. As the print was first, it must not have been enough, and I
moved it to the token, but kept the first concat there.

I still want to hold off on this patch just to make sure there's not
something else that was missed.

Thanks,

-- Steve


