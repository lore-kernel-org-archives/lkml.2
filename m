Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab0DFOsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 10:48:12 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45267 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab0DFOsF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 10:48:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=QGRt6+TuMRdFejvBh+fyyeP7BMYRvGkfXvHwgz/SNguNVphRR64UVaKpiDrn1o14wO
         CeS3jjWiZXlGg50f4VNI2wo7/ywzRReZ3dXKn5eEub1YXrJrrsyVsxBLEFmju4xTqZYW
         51Epxulb5xGiv+iseM/3ZTMcTpDEqmn0d+peE=
MIME-Version: 1.0
In-Reply-To: <1270543721.1597.748.camel@laptop>
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com> 
	<4BBA5305.7010002@redhat.com> <1270543721.1597.748.camel@laptop>
From: Ulrich Drepper <drepper@gmail.com>
Date: Tue, 6 Apr 2010 07:47:41 -0700
Message-ID: <m2ua36005b51004060747y1abf15edj28227274844db2e7@mail.gmail.com>
Subject: Re: [PATCH V2 0/6][RFC] futex: FUTEX_LOCK with optional adaptive 
	spinning
To: Peter Zijlstra <peterz@infradead.org>
Cc: Avi Kivity <avi@redhat.com>, Darren Hart <dvhltc@us.ibm.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 6, 2010 at 01:48, Peter Zijlstra <peterz@infradead.org> wrote:
>  try
>  spin
>  try
>  syscall

This is available for a long time in the mutex implementation
(PTHREAD_MUTEX_ADAPTIVE_NP mutex type).  It hasn't show much
improvement if any.  There were some people demanding this support for
as far as I know they are not using it now.  This is adaptive
spinning, learning from previous calls how long to wait.  But it's
still unguided.  There is no way to get information like "the owner
has been descheduled".
