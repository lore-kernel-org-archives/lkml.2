Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab1HSJxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 05:53:48 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:64855 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab1HSJxp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 05:53:45 -0400
MIME-Version: 1.0
In-Reply-To: <1312891671-28680-1-git-send-email-per.forlin@linaro.org>
References: <1312891671-28680-1-git-send-email-per.forlin@linaro.org>
Date: Fri, 19 Aug 2011 11:53:44 +0200
Message-ID: <CAJ0pr1-8Jnk1CKakWcS6T4Q3bAe7sF=5p8+9ou1+SbxsZM_Svw@mail.gmail.com>
Subject: Re: [PATCH --mmotm v8 0/3] Make fault injection available for MMC IO
From: Per Forlin <per.forlin@linaro.org>
To: Akinobu Mita <akinobu.mita@gmail.com>, akpm@linux-foundation.org,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        linux-kernel@vger.kernel.org, Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, linaro-dev@lists.linaro.org, linux-mm@kvack.org,
        Per Forlin <per.forlin@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

It's no longer necessary to merge this through the mm-tree since
Akinobu's patch "fault-injection: add ability to export fault_attr in
arbitrary directory" is in mainline.
Chris, would you mind merging the fault-injection patches in this
patchset to mmc-next once the mmc part of this patchset is acked and
accepted?

Regards,
Per

On 9 August 2011 14:07, Per Forlin <per.forlin@linaro.org> wrote:
> change log:
>  v2 - Resolve build issue in mmc core.c due to multiple init_module by
>      removing the fault inject module.
>    - Export fault injection functions to make them available for modules
>    - Update fault injection documentation on MMC IO
>  v3 - add function descriptions in core.c
>    - use export GPL for fault injection functions
>  v4 - make the fault_attr per host. This prepares for upcoming patch from
>      Akinobu that adds support for creating debugfs entries in
>      arbitrary directory.
>  v5 - Make use of fault_create_debugfs_attr() in Akinobu's
>      patch "fault-injection: add ability to export fault_attr in...".
>  v6 - Fix typo in commit message in patch "export fault injection functions"
>  v7 - Don't compile in boot param setup function if mmc-core is
>      built as module.
>  v8 - Update fault injection documentation.
>      Add fail_mmc_request to boot option section.
>
> Per Forlin (3):
>  fault-inject: export fault injection functions
>  mmc: core: add random fault injection
>  fault injection: add documentation on MMC IO fault injection
>
>  Documentation/fault-injection/fault-injection.txt |    8 +++-
>  drivers/mmc/core/core.c                           |   44 +++++++++++++++++++++
>  drivers/mmc/core/debugfs.c                        |   27 +++++++++++++
>  include/linux/mmc/host.h                          |    7 +++
>  lib/Kconfig.debug                                 |   11 +++++
>  lib/fault-inject.c                                |    2 +
>  6 files changed, 98 insertions(+), 1 deletions(-)
>
> --
> 1.7.4.1
>
>
