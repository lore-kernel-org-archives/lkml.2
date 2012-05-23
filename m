Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282Ab2EWIn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 04:43:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4659 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932960Ab2EWInZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 04:43:25 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=8ShOI8NZQckA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=ZWHCA0HOB0jr8hT7BuEA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337762603.13348.139.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] Use test_and_clear_bit() instead atomic_dec_and_test()
 for stop_machine
From: Steven Rostedt <rostedt@goodmis.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 23 May 2012 04:43:23 -0400
In-Reply-To: <87mx4zr0l9.fsf@devron.myhome.or.jp>
References: <87likkt7u6.fsf@devron.myhome.or.jp>
	 <87ehqct7a3.fsf@devron.myhome.or.jp>
	 <20120522214633.GB30024@home.goodmis.org>
	 <87aa0zty4r.fsf@devron.myhome.or.jp> <87mx4zr0l9.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 13:19 +0900, OGAWA Hirofumi wrote:
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> 
> 
> stop_machine_first is just to see if it is first one or not.  In this
> usage, atomic_dec_and_test() makes value less than 0.
> 
> I think it is not desirable, because it only triggers
> atomic_dec_and_test() less than 0 debug patch. (the patch tests result
> of atomic_dec_and_test() is < 0)
> 
> So, this uses atomic_xchg() instead.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> 
> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>


