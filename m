Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667Ab1A3AVJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 19:21:09 -0500
Received: from cantor.suse.de ([195.135.220.2]:60305 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab1A3AVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 19:21:07 -0500
Subject: Re: [PATCH RFC] serial-core: reset the console speed on resume
From: Stanislav Brabec <sbrabec@suse.cz>
To: Yin Kangkai <kangkai.yin@linux.intel.com>
Cc: linux-serial <linux-serial@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Deepak Saxena <dsaxena@laptop.org>,
        Jason Wang <jason77.wang@gmail.com>, Daniel Drake <dsd@laptop.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110125104302.GM3315@kai-debian>
References: <20110125104302.GM3315@kai-debian>
Content-Type: text/plain; charset="ISO-8859-2"
Organization: SUSE Linux, s. r. o.
Date: Sun, 30 Jan 2011 01:20:58 +0100
Message-ID: <1296346859.5397.29.camel@utx.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yin Kangkai wrote on Tue 25 Jan 2011 at 18:43 +0800:

> On some platforms, we need to restore the console speed on resume even
> it was not suspended (no_console_suspend), and on others we don't have
> to do that.
> 
> So don't care about the "console_suspend_enabled" and unconditionally
> reset the console speed if it is a console.

Well, there is currently another breakage on Zaurus. But it improves the
situation.
(Note: Your patch has bad file path. I'll agree with such change after
this fix.)

Test report on Zaurus
(serial hardware itself is in undefined state after resume):

                                       before  after
login:                                   OK     OK
console:                               broken broken
console + login:                         OK     OK
console + no_console_suspend:          broken broken
login + no_console_suspend:              OK     OK
console + login + no_console_suspend:  broken   OK

-- 
Best Regards / S pozdravem,

Stanislav Brabec
software developer
---------------------------------------------------------------------
SUSE LINUX, s. r. o.                          e-mail: sbrabec@suse.cz
Lihovarská 1060/12                            tel: +49 911 7405384547
190 00 Praha 9                                  fax: +420 284 028 951
Czech Republic                                    http://www.suse.cz/

