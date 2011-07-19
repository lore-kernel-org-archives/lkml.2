Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421Ab1GSOep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 10:34:45 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:42406 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab1GSOen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 10:34:43 -0400
Subject: Re: [PATCH] Add error check to hex2bin().
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-security-module@vger.kernel.org,
        andriy.shevchenko@linux.intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAHp75VdTiMtmXdVSMq=6bAH2+rmSBHPPE9hQOLQN+Y3qPBEVFg@mail.gmail.com>
References: <1310977597-9666-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <201107182041.EHB78622.VOFSHFMOOFtLJQ@I-love.SAKURA.ne.jp>
	 <1310991796.3903.6.camel@smile>
	 <201107182148.AGD21306.FOLtJVMSOOFQHF@I-love.SAKURA.ne.jp>
	 <CAMuHMdVxR7AC7H_Yys8SiaGqM2JsNXLsRpujqojMYd_CXWxcAw@mail.gmail.com>
	 <CAHp75VdTiMtmXdVSMq=6bAH2+rmSBHPPE9hQOLQN+Y3qPBEVFg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jul 2011 21:00:54 -0400
Message-ID: <1311037254.3648.209.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry for re-posting, but this doesn't seem to have been sent.)

On Tue, 2011-07-19 at 00:18 +0300, Andy Shevchenko wrote:
> On Mon, Jul 18, 2011 at 11:49 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > What about making it return the number of unprocessed bytes left instead?
> > Then the caller knows where the problem lies. And zero would mean success.
> If I remember correctly it used to be src as return value in some
> version of that patch. I don't know the details of that interim
> solution. My current opinion is to return boolean and make an
> additional parameter to return src value. However, it could make this
> simple function fat.
> P.S. Take into account that the user of it is only one so far, I would
> like to hear a Mimi's opinion.
> 

Trusted/encrypted keys are not in a critical code path. They're used for
loading/storing key blobs from userspace. Once you change the API, short
circuiting out and adding an error return, from a trusted/encrypted key
perspective, it doesn't make a difference.

thanks,

Mimi

