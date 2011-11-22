Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291Ab1KVRo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 12:44:28 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60942 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758256Ab1KVRo0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 12:44:26 -0500
MIME-Version: 1.0
In-Reply-To: <201111221307.14942.arnd.bergmann@linaro.org>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org>
 <1321926047-14211-6-git-send-email-mturquette@linaro.org> <201111221307.14942.arnd.bergmann@linaro.org>
From: Mike Turquette <mturquette@linaro.org>
Date: Tue, 22 Nov 2011 09:42:58 -0800
Message-ID: <CAPtuhTiVR6NQfgH6-JGd6EC68bdOb6JwDKqaiswS8YR3sNt-Vg@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] clk: export tree topology and clk data via sysfs
To: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: Mike Turquette <mturquette@ti.com>, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jeremy.kerr@canonical.com,
        broonie@opensource.wolfsonmicro.com, tglx@linutronix.de,
        linus.walleij@stericsson.com, amit.kucheria@linaro.org,
        dsaxena@linaro.org, patches@linaro.org, linaro-dev@lists.linaro.org,
        aul@pwsan.com, grant.likely@secretlab.ca, sboyd@quicinc.com,
        shawn.guo@freescale.com, skannan@quicinc.com, magnus.damm@gmail.com,
        eric.miao@linaro.org, richard.zhao@linaro.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 5:07 AM, Arnd Bergmann <arnd.bergmann@linaro.org> wrote:
> On Tuesday 22 November 2011, Mike Turquette wrote:
>> Introduces kobject support for the common struct clk, exports per-clk
>> data via read-only callbacks and models the clk tree topology in sysfs.
>>
>> Also adds support for generating the clk tree in clk_init and migrating
>> nodes when input sources are switches in clk_set_parent.
>>
>> Signed-off-by: Mike Turquette <mturquette@linaro.org>
>> ---
>>  drivers/clk/Kconfig     |   10 +++
>>  drivers/clk/Makefile    |    1 +
>>  drivers/clk/clk-sysfs.c |  199 +++++++++++++++++++++++++++++++++++++++++++++++
>>  drivers/clk/clk.c       |    5 +-
>>  include/linux/clk.h     |   36 ++++++++-
>>  5 files changed, 248 insertions(+), 3 deletions(-)
>>  create mode 100644 drivers/clk/clk-sysfs.c
>
> Since this introduces a new top-level hierarchy in sysfs, it certainly needs
> to be reviewed by Greg K-H (on Cc now). Also, you have to add a proper
> documentation for every new node and attribute in Documentation/ABI along
> with the code.

I don't intend to keep it in the top-level /sys/ directory.  I
mentioned that in the coverletter, but not here.  I wasn't sure where
to put it, and I knew reviewers would be happy to point the right
place out to me.

>> +static struct kobject *clk_kobj;
>> +LIST_HEAD(kobj_list);
>
> The list head should be static.

Will put into V4.

Thanks,
Mike

>
>        Arnd
>
