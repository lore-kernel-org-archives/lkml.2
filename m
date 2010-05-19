Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab0ESSVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 14:21:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58494 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359Ab0ESSVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 14:21:05 -0400
Message-ID: <4BF42A5E.6060503@zytor.com>
Date: Wed, 19 May 2010 11:13:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Autofs <autofs@linux.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       John Kacur <jkacur@redhat.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/8] autofs: Pushdown the bkl from ioctl
References: <1274289855-10001-1-git-send-regression-fweisbec@gmail.com> <1274289855-10001-3-git-send-regression-fweisbec@gmail.com> <4BF4279C.2000805@zytor.com> <20100519180832.GA9752@nowhere>
In-Reply-To: <20100519180832.GA9752@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2010 11:08 AM, Frederic Weisbecker wrote:
> On Wed, May 19, 2010 at 11:02:04AM -0700, H. Peter Anvin wrote:
>> On 05/19/2010 10:24 AM, Frederic Weisbecker wrote:
>>>   * generate kernel reactions
>>>   */
>>> -static int autofs_root_ioctl(struct inode *inode, struct file *filp,
>>> +static int autofs_root_ioctl_unlocked(struct inode *inode, struct file *filp,
>>>  			     unsigned int cmd, unsigned long arg)
>>>  {
>>>  	struct autofs_sb_info *sbi = autofs_sbi(inode->i_sb);
>>> @@ -579,3 +579,16 @@ static int autofs_root_ioctl(struct inode *inode, struct file *filp,
>>>  		return -ENOSYS;
>>>  	}
>>>  }
>>> +
>>> +static long autofs_root_ioctl(struct file *filp,
>>> +			     unsigned int cmd, unsigned long arg)
>>> +{
>>
>> The choice of naming here seems reverse in my opinion.
> 
> 
> Oh, why?
> 
> The function that holds the bkl calls its unlocked version.
> 

But it's not ... it is locked at that point.  It's not lock*ing*, but it
is not *unlocked*, either.  Furthermore, it is directly contradicting
the naming scheme of the ops structure.

	-hpa

