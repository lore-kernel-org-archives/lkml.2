Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab1ADTNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 14:13:40 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:57822 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab1ADTNj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 14:13:39 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=H95gfW32JB/XYJSBuOTvJ8IIviFcsPdfxXHbM7LS6jM= c=1 sm=1
 a=0QKFYxT7T6UA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10 a=xqWC_Br6kY4A:10
 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=M_OXT13CiP2tJL5tjDQA:9
 a=DbwZjF02ryyCBxxI24sA:7 a=orUTy5U_4DvFXFA-J5E328yDcZQA:4 a=CjuIK1q_8ugA:10
 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Subject: Re: [PATCH resend] Update atime from future.
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <13585.1294165307@localhost>
Date: Tue, 4 Jan 2011 12:13:37 -0700
Cc: yangsheng <sickamd@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        swhiteho@redhat.com, sickadm@gmail.com
Content-Transfer-Encoding: 8BIT
Message-Id: <2321F6F6-1042-48E8-9F21-12C52E8FFFCC@dilger.ca>
References: <1294131418-3835-1-git-send-email-sickamd@gmail.com> <13585.1294165307@localhost>
To: Valdis.Kletnieks@vt.edu
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-04, at 11:21, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 04 Jan 2011 16:56:58 +0800, yangsheng said:
>> If atime has been wrong set to future, then it cannot
>> be updated back to current time.
>> 
>> +#define RELATIME_MARGIN (24 * 60 * 60)
> 
> Nice patch overall.  Should this be a #define, or a CONFIG_ variable,
> or a tweakable /proc/sys/fs variable?  Or am I senile and we thrashed
> all this out once before when the relatime code landed?

I recall the consensus was that a /proc tunable was "too much" for the initial patch.  An atime update interval of 1 day is sufficient for most applications, since they run daily to do file access scanning.  The #define was added because I dislike having multiple hard-coded values in any code.

I haven't heard of any complaints about the relatime update frequency, except for this "atime in the future" problem, so until that happens we may as well leave it as-is.

Cheers, Andreas





