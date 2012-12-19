Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab2LSUps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 15:45:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121Ab2LSUpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 15:45:34 -0500
Message-ID: <50D22766.9090107@redhat.com>
Date: Wed, 19 Dec 2012 21:45:26 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Thunderbird/5.0
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Kernel Team <kernel-team@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org, jgarzik@redhat.com,
        JBottomley@Parallels.com
Subject: Re: [v3.7 Regression]  [SCSI] sd: Implement support for WRITE SAME
References: <50CB8C74.3090102@canonical.com> <yq11uesdzya.fsf@sermon.lab.mkp.net> <50D0C971.1000907@canonical.com> <yq1bodq7zdv.fsf@sermon.lab.mkp.net> <20121219195801.GA14456@redhat.com>
In-Reply-To: <20121219195801.GA14456@redhat.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2012 08:58 PM, Mike Snitzer wrote:
> On Wed, Dec 19 2012 at 11:58am -0500,
> Martin K. Petersen <martin.petersen@oracle.com> wrote:
> 
>>>>>>> "Joseph" == Joseph Salisbury <joseph.salisbury@canonical.com> writes:
>>
>> Joseph> I captured the netconsole output from boot until I reproduced
>> Joseph> the bug. The RIP points to kcryptd_crypt_write_io_submit() in
>> Joseph> ~/drivers/md/dm-crypt.c.  The output can be seen at:
>>
>> I'm thinking that dm-crypt should probably set max_write_same_sectors to
>> 0. It doesn't really make much sense for a crypto driver to pass that
>> command through.

IMHO WRITE_SAME doesn't not make sense in encrypted storage. The same sectors
in plaintext are _not_ the same in ciphertext. NEVER.
(If so, you have a security problem.)

It must be disabled in dmcrypt explicitly then (max_write_same_sectors?).

Is it only dmcrypt, or encrypted fs are affected too?

Milan

