Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760529Ab0I1Jjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 05:39:47 -0400
Received: from mx3.orcon.net.nz ([219.88.242.53]:58931 "EHLO mx3.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760412Ab0I1Jjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 05:39:46 -0400
Message-ID: <4CA1B7DF.10202@orcon.net.nz>
Date: Tue, 28 Sep 2010 22:39:43 +1300
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100913 Icedove/3.0.7
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: linux-kernel@vger.kernel.org, mattst88@gmail.com,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 1/2] alpha: switch osf_sigprocmask() to use of sigprocmask()
References: <E1OzvxM-0002ng-B5@ZenIV.linux.org.uk>
In-Reply-To: <E1OzvxM-0002ng-B5@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-DSPAM-Check: by mx3.orcon.net.nz on Tue, 28 Sep 2010 22:39:44 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Tue Sep 28 22:39:44 2010
X-DSPAM-Confidence: 0.7413
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/09/10 07:28, Al Viro wrote:
>
> get rid of a useless wrapper, while we are at it
>
> Signed-off-by: Al Viro<viro@zeniv.linux.org.uk>

Compiling this leads to the following errors:

arch/alpha/kernel/signal.c: In function ‘SYSC_osf_sigprocmask’:
arch/alpha/kernel/signal.c:52: error: implicit declaration of function 
‘siprocmask’
arch/alpha/kernel/signal.c:55: error: invalid type argument of ‘->’ 
(have ‘sigset_t’)

Obviously it should be sigprocmask at line 52, and presumably line 55 
which is currently

		res = oldmask->sig[0];

should be

		res = oldmask.sig[0];

Cheers
Michael.
