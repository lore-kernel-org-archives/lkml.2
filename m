Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab1A0VvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 16:51:18 -0500
Received: from smtp-out.google.com ([74.125.121.67]:21633 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab1A0VvR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 16:51:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=KQhv0wkYlJ5BqqNDbPKTDwOZ+XOYISxDN92HOY96mRDxFjOB5em8J5ksGgXevx7lcq
         kX6IZ5umdtQG3lFMlDRg==
MIME-Version: 1.0
In-Reply-To: <4D41D7C2.3080608@codeaurora.org>
References: <1295834493-5019-1-git-send-email-ccross@android.com>
	<1295834493-5019-19-git-send-email-ccross@android.com>
	<4D41D7C2.3080608@codeaurora.org>
Date: Thu, 27 Jan 2011 13:51:13 -0800
X-Google-Sender-Auth: BGPHZv5CS6Fpajt859syF914YvI
Message-ID: <AANLkTi=o5o2_4Ur2GTS=0XSoYqFMYqSF99aU9N_wxWuu@mail.gmail.com>
Subject: Re: [PATCH v2 18/28] ARM: tegra: add CPU_IDLE driver
From: Colin Cross <ccross@android.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-tegra@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        konkers@android.com, Gary King <gking@nvidia.com>,
        linux-kernel@vger.kernel.org, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 12:38 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 01/23/2011 06:01 PM, Colin Cross wrote:
>>
>> +static int __init tegra_cpuidle_debug_init(void)
>> +{
>> +     struct dentry *dir;
>> +     struct dentry *d;
>> +
>> +     dir = debugfs_create_dir("cpuidle", NULL);
>> +     if (!dir)
>> +             return -ENOMEM;
>> +
>> +     d = debugfs_create_file("lp2", S_IRUGO, dir, NULL,
>> +             &tegra_lp2_debug_ops);
>> +     if (!d)
>> +             return -ENOMEM;
>> +
>> +     return 0;
>> +}
>> +#endif
>> +
>> +late_initcall(tegra_cpuidle_debug_init);
>
> Will this compile with CONFIG_DEBUG_FS=n?

Yes.  All debugfs ops return ERR_PTR(-ENODEV) if CONFIG_DEBUG_FS=n, so
tegra_cpuidle_debug_init will do nothing and return 0.
