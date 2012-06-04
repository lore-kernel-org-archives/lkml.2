Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab2FDJ5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 05:57:04 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:36900 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751602Ab2FDJ5C convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 05:57:02 -0400
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?iso-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Date: Mon, 4 Jun 2012 11:56:47 +0200
Subject: RE: [RFC 3/6] remoteproc: Move fw sanity check to find_rsc_table.
Thread-Topic: [RFC 3/6] remoteproc: Move fw sanity check to find_rsc_table.
Thread-Index: Ac1BjrqFlXL0CpWUT/qRY8MgZ1E11QApAXwQ
Message-ID: <81C3A93C17462B4BBD7E272753C10579232F4FBCF7@EXDCVYMBSTM005.EQ1STM.local>
References: <1337693217-15466-1-git-send-email-sjur.brandeland@stericsson.com>
 <1337693217-15466-4-git-send-email-sjur.brandeland@stericsson.com>
 <CAK=Wgbbdjf_SnbxQJd04nPSFBbHQQwO5zP_gW_jTiJyj_rn63g@mail.gmail.com>
In-Reply-To: <CAK=Wgbbdjf_SnbxQJd04nPSFBbHQQwO5zP_gW_jTiJyj_rn63g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Prepare for pluggable firmware handling by calling firmware
>> sanity check from function find_rsc_table.
> 
> Can we keep the present location of rproc_fw_sanity_check(), and later
> just invoke the relevant ops handler instead?

The sanity_check() is working on the ELF structures. And all ELF
processing needs to be moved to a separate file. So if you want
to keep the call to sanity_check() here, I need to make the
sanity_check() function a separate handler. That could make sense,
but will also bloat the struct rproc_fw_ops with one more function
pointer.

Regards,
Sjur
