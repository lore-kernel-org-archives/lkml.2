Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab2FCNon (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 09:44:43 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:33336 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab2FCNom convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 09:44:42 -0400
MIME-Version: 1.0
X-Originating-IP: [85.250.83.253]
In-Reply-To: <CAK=WgbafpAC+DZ71Oon_PyiWGAryAxzZvttpeiFY+A_agYcMFw@mail.gmail.com>
References: <1337693217-15466-1-git-send-email-sjur.brandeland@stericsson.com>
 <1337693217-15466-3-git-send-email-sjur.brandeland@stericsson.com> <CAK=WgbafpAC+DZ71Oon_PyiWGAryAxzZvttpeiFY+A_agYcMFw@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 3 Jun 2012 16:44:21 +0300
Message-ID: <CAK=WgbZXHvTQmQZ3Y9ZBLREmsfZx4Bk8Y-H42_1c_j3ZFSqgPQ@mail.gmail.com>
Subject: Re: [RFC 2/6] remoteproc: Pass struct fw to load_segments and find_rsc_table.
To: sjur.brandeland@stericsson.com
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 3, 2012 at 3:54 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
>> +rproc_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
>>                                                        int *tablesz)
>>  {
> ...
>> +       /*
>> +        * The ELF entry point is the rproc's boot addr (though this is not
>> +        * a configurable property of all remote processors: some will always
>> +        * boot at a specific hardcoded address).
>> +        */
>> +       rproc->bootaddr = ehdr->e_entry;

We might want to dedicate this (humble) hunk its own handler, because
I'm not sure it fits very well into rproc_find_rsc_table().

Thanks,
Ohad.
