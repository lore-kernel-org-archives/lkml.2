Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab1BDVeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 16:34:37 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56648 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab1BDVef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 16:34:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=jjAU/bJUBsRa+I9/J1I7LXTVztJ/sUlgI9/tfw5jmBxaD6T8Tc5FiAkuIvVQS1xayq
         zimKKEDsNuUPCpWH8tMwsLseMKqu+WdPVuRXhf3t/Krry5t3yhoTBMcl2HOEErQtbFDB
         LqHEI04gHhxQJcjU/JFdGn/OlYEegGMHL6xlI=
MIME-Version: 1.0
In-Reply-To: <m1vd0zh5eh.fsf@fess.ebiederm.org>
References: <m1oc6rio5u.fsf@fess.ebiederm.org> <1296851485-6730-1-git-send-email-lucian.grijincu@gmail.com>
 <m1vd0zh5eh.fsf@fess.ebiederm.org>
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Fri, 4 Feb 2011 23:34:14 +0200
Message-ID: <AANLkTinALtUX=uBGtCiVjyEMQJZ0O_Fc39nu3d1zSKkB@mail.gmail.com>
Subject: Re: [PATCH 1/6] sysctl: faster reimplementation of sysctl_check_table
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Octavian Purdila <opurdila@ixiacom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p14LYm92030853

On Fri, Feb 4, 2011 at 11:11 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>> +static int __sysctl_check_table(struct nsproxy *namespaces,
>> + Â  Â  struct ctl_table *table, struct ctl_table **parents, int depth)
>> Â {
>> + Â  Â  const char *fail = NULL;
>> Â  Â  Â  int error = 0;
>> +
>> + Â  Â  if (depth >= CTL_MAXNAME) {
>
> This should be depth > CTL_MAXNAME. Â Because there are only CTL_MAXNAME
> entries in the array.


A bit lower in the array we access 'parents[depth]'.
So the correct check should be (depth >= CTL_MAXNAME) => error.


>> - Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  sysctl_check_leaf(namespaces, table, &fail);
>> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  parents[depth] = table;
>> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  sysctl_check_leaf(namespaces, table, &fail,
>> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  parents, depth);
>> Â  Â  Â  Â  Â  Â  Â  }

>> + Â  Â  Â  Â  Â  Â  if (table->child) {
>> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  parents[depth] = table;
>> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  error |= __sysctl_check_table(namespaces, table->child,
>> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  parents, depth + 1);
>> + Â  Â  Â  Â  Â  Â  }



-- 
Â .
..: Lucian
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
