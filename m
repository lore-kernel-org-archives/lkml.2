Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009Ab0HWQiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 12:38:16 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57581 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab0HWQiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 12:38:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oXuI2wOqHki0TlCplBba7M7ywvmRcjwjZCaLEf3nhiGQRLd0+hh++IJGtDpDam/SNx
         ZQCmQLJMxvQ2flXoL1MJfHZguA5jIaKgzq0Ts5myeyKsNzUiwDdEruv+f/tkyCqn4w+I
         IC4E8cffoDEutO11fPfFzSMBP7NPv/2+PRbTk=
Subject: Re: [PATCH 2/3 RESEND] ptrace: cleanup address space conversion on
 ptrace_request()
From: Namhyung Kim <namhyung@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Roland McGrath <roland@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100823162105.GA19164@infradead.org>
References: <201008222206.18523.arnd@arndb.de>
	 <1282579575-9189-1-git-send-email-namhyung@gmail.com>
	 <20100823162105.GA19164@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 01:38:09 +0900
Message-ID: <1282581489.1659.13.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-08-23 (Mon), 12:21 -0400, Christoph Hellwig:
> Just make this a
> 
> 	void __user *datap = (void __user *)data;
> 
> and you can pass it around withjout additional casts.  Also no need
> for the force here I think.
> 

But removing __force results in following sparse warning:

 ptrace.c:567:40: warning: cast adds address space to expression
(<asn:1>)


-- 
Regards,
Namhyung Kim


