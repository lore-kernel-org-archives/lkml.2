Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab1FNOJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 10:09:36 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51055 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab1FNOJf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 10:09:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Oq2Snss4hkjaPm9biqZXZtvqzIxscAWS2qs7tqkb6/OJUslAXXaiouAk6UNh7DfEEE
         506TSrqc9RYNDh0GAPZIw8WlC5Ht/t3DEkEBlGHIRMvm7XLBrNaeCfh1P00RABMpI4LW
         55lUiXLCYYzZz++fzlCbQIVxZzitHZMGAbGSE=
MIME-Version: 1.0
In-Reply-To: <20110614071540.GE8141@htj.dyndns.org>
References: <20110614070732.GA3355@maxin>
	<20110614071540.GE8141@htj.dyndns.org>
Date: Tue, 14 Jun 2011 15:09:34 +0100
Message-ID: <BANLkTimHjVX6ymALT-ZBeSs1S+PRDRwQaQ@mail.gmail.com>
Subject: Re: [PATCH] [RESEND] devres: Fix possible use after free
From: Maxin B John <maxin.john@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, segooon@gmail.com, jkosina@suse.cz,
        tglx@linutronix.de, eike-kernel@sf-tec.de,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jun 14, 2011 at 8:15 AM, Tejun Heo <tj@kernel.org> wrote:
> On Tue, Jun 14, 2011 at 10:07:32AM +0300, Maxin B John wrote:
>> A freed pointer is passed as an argument to the function "devres_destroy()" in
>> "kernel/irq/devres.c" and "lib/devres.c". This patch fixes the possible use
>> after free.
>>
>> It's notabug at this time, but the code is dangerous.
>
> The code is not dangerous.  The pointer value is used strictly as key
> and the code path is always properly serialized.  The change is to
> appease access-after-free detection logic, similar to the way we
> change the code to better accomodate sparse or other code analysys
> tools.  Can you please update the patch description to reflect that?

You are right. I shouldn't have mentioned it as dangerous. I was trying to
make this patch description similar to the description present in the
previous patch:
http://www.spinics.net/lists/mm-commits/msg84313.html

This patch silences the Coverity Prevent's complains about this as
use-after-free bug. Please let me know if the updated patch description is OK.

"
A freed pointer is passed as an argument to the function "devres_destroy()" in
"kernel/irq/devres.c" and "lib/devres.c". This patch fixes the possible use
after free.
The change silences the static analysis tool (Coverity Prevent) complains
about this as use-after-free bug.
"

Best Regards,
Maxin
