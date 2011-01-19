Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab1ASE5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 23:57:37 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61579 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab1ASE5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 23:57:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kSP4ceXiVRtYkXHsgfnrdiOjMyAt+H/mpgFvqr2XiRY8b1g63rfMORCZfrdOsVWxn4
         f/oEf09GEt3xRCb14n9FA2NklK5zFtxlxRD9q3kcKy27RLi/TzJUQC9/sUkkFw9kM3jp
         W7dNMrAuyyhGNsmnP6BptsQ6ozjYe5hK31o9c=
Date: Wed, 19 Jan 2011 12:57:24 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Rob Landley <rlandley@parallels.com>
Cc: Jesper Juhl <jj@chaosbits.net>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Tejun Heo <tj@kernel.org>, Don Zickus <dzickus@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use sed instead of perl to generate
 x86/kernel/cpu/capflags.c.
Message-ID: <20110119045724.GB9903@cr0.nay.redhat.com>
References: <4D334E1E.7090708@parallels.com>
 <alpine.LNX.2.00.1101162103450.13377@swampdragon.chaosbits.net>
 <4D335554.7020403@parallels.com>
 <alpine.LNX.2.00.1101162136360.13377@swampdragon.chaosbits.net>
 <4D35FEF3.4070001@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D35FEF3.4070001@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 02:58:27PM -0600, Rob Landley wrote:
>
>From: Rob Landley <rlandley@parallels.com>
>
>Replace perl header file generator with smaller/faster/simpler C version.
>
>Signed-off-by: Rob Landley <rlandley@parallels.com>

Pretty nice!

One small problem below.

>
>I ran the attached test script to compare the output of the C program
>with the output of the perl version for every HZ from 1 to 5000 to make
>sure it was producing the same constants.
>


I think you can use diff to compare the perl output and C output,
with different HZ values.


>+	fprintf(file, "#endif /* __KERNEL_TIMECONST_H */\n");
>+
>+	/* Notice if the disk fills up. */
>+
>+	fflush(stdout);
>+	return ferror(stdout);


Why do you fflush stdout while you are writing to 'file'?

Thanks.
