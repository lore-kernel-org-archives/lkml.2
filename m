Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab2B0N5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 08:57:13 -0500
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:52526 "EHLO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab2B0N5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 08:57:12 -0500
Message-ID: <4F4B8BB2.1060004@ge.com>
Date: Mon, 27 Feb 2012 13:57:06 +0000
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linuxppc-dev@lists.ozlabs.org, Wim Van Sebroeck <wim@iguana.be>,
        Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] powerpc: Move GE GPIO and PIC drivers
References: <1328614121-17803-1-git-send-email-martyn.welch@ge.com>	 <1328614121-17803-2-git-send-email-martyn.welch@ge.com> <1330299464.20389.58.camel@pasglop>
In-Reply-To: <1330299464.20389.58.camel@pasglop>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Feb 2012 13:57:09.0329 (UTC) FILETIME=[B28A9C10:01CCF557]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/02/12 23:37, Benjamin Herrenschmidt wrote:
> On Tue, 2012-02-07 at 11:28 +0000, Martyn Welch wrote:
>> Move the GE GPIO and PIC drivers to allow these to be used by non-86xx
>> boards.
> 
> Hi, Sorry for the late review...
> 

No problem, thanks for the review!

>> Signed-off-by: Martyn Welch <martyn.welch@ge.com>
>> ---
>>  arch/powerpc/platforms/86xx/Kconfig      |    3 +
>>  arch/powerpc/platforms/86xx/Makefile     |    7 +-
>>  arch/powerpc/platforms/86xx/gef_gpio.c   |  171 --------------------
>>  arch/powerpc/platforms/86xx/gef_pic.c    |  252 ------------------------------
>>  arch/powerpc/platforms/86xx/gef_pic.h    |   11 --
>>  arch/powerpc/platforms/86xx/gef_ppc9a.c  |    3 +-
>>  arch/powerpc/platforms/86xx/gef_sbc310.c |    3 +-
>>  arch/powerpc/platforms/86xx/gef_sbc610.c |    3 +-
>>  arch/powerpc/platforms/Kconfig           |    7 +
>>  arch/powerpc/platforms/Makefile          |    3 +
>>  arch/powerpc/platforms/ge_gpio.c         |  171 ++++++++++++++++++++
>>  arch/powerpc/platforms/ge_pic.c          |  252 ++++++++++++++++++++++++++++++
>>  arch/powerpc/platforms/ge_pic.h          |   11 ++
> 
> So I don't like having files showing up there. In fact, I want to move
> the only other one here, it's not the right place for it
> (fsl_uli1575.c).
> 

This patch (or one like it) has been around for a while now. Kumar wanted me
to put them here rather than sysdev[1], but I'm easy either way.

> Please contemplate using arch/powerpc/sysdev instead. Maybe make a
> subdir in there (geip or something like that ?)
> 

I'd rather avoid "geip" (we seem to have a habit of renaming divisions), would
"ge" be acceptable?

> Also, use git mv so that the file moves appear as such in the history,
> this will make review easier by clearly separating the move from actual
> changes to the files.
> 

Hmm, thought I'd done that. Will try again.

Martyn

[1] http://old.nabble.com/GE-GPIO-and-PIC-support.-td27212938.html

-- 
Martyn Welch (Lead Software Engineer)  | Registered in England and Wales
GE Intelligent Platforms               | (3828642) at 100 Barbirolli Square
T +44(0)1327322748                     | Manchester, M2 3AB
E martyn.welch@ge.com                  | VAT:GB 927559189
