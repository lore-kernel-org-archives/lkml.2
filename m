Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab2FYSXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 14:23:55 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:61953 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab2FYSXy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 14:23:54 -0400
MIME-Version: 1.0
In-Reply-To: <4FE88E9A.4040605@xenotime.net>
References: <1340637580-12711-1-git-send-email-aletes.xgr@gmail.com>
	<4FE88E9A.4040605@xenotime.net>
Date: Mon, 25 Jun 2012 15:23:53 -0300
Message-ID: <CAAAP30Gmfw-wLztrb7HUbeWYo5zAac6DOnewOJNPz0zXEy03zQ@mail.gmail.com>
Subject: Re: [PATCH] ubifs: Fix build warning
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 1:15 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 06/25/2012 08:19 AM, Alexandre Pereira da Silva wrote:
>
>> Fix:
>> fs/ubifs/dir.c: In function 'ubifs_rename':
>> fs/ubifs/dir.c:972:15: warning: 'saved_nlink' may be used uninitialized
>> in this function
>>
>> Initilize saved_nlink to 0
>
> Does nlink need to be init at all?  is the warning bogus or valid?

>From the code, this is a bogus warning.

> If the warning is bogus, the preferred solution is:
>
> #include <linux/compiler-gcc.h>
> ...
>        unsigned int uninitialized_var(nlink);

I will fix the patch as suggested. Thanks.
