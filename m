Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636Ab1GZRRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 13:17:46 -0400
Received: from smtp-out.google.com ([74.125.121.67]:29237 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab1GZRRk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 13:17:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=IVhoQxxmbbTQEVrm9uMHKm5mpN4gKkdI42iY2zli1cO2PtvutfYmNV5fXqysSwcFm
	M8of0VQ89yy/mtlHgt1Tg==
MIME-Version: 1.0
In-Reply-To: <20110726144427.GB13780@redhat.com>
References: <1311573834-7140-1-git-send-email-gaowanlong@cn.fujitsu.com>
 <1311645400-19434-1-git-send-email-gaowanlong@cn.fujitsu.com> <20110726144427.GB13780@redhat.com>
From: Paul Menage <menage@google.com>
Date: Tue, 26 Jul 2011 10:17:16 -0700
Message-ID: <CAJniumVm=oH_yJAgaTzwVu1XwJfn8eAsHw2Cm0tfvg=unA6hkA@mail.gmail.com>
Subject: Re: [PATCH v3] blk-cgroup:be able to remove the record of unplugged device
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>, lizf@cn.fujitsu.com,
        axboe@kernel.dk, linux-kernel@vger.kernel.org, wanlong.gao@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 7:44 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>>       char *s[4], *p, *major_s = NULL, *minor_s = NULL;
>>       int ret;
>> -     unsigned long major, minor, temp;
>> +     unsigned long major, minor, weight;
>
> Do not replace temp with name weight. The place you are parsing it,
> it could be weight, bps or iops. So lets keep the generic name in
> place.

The variable currently called "temp" is only ever stored in
newpn->val.weight. iops and bps already have their own local
variables.

Paul
