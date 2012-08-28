Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab2H1KCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 06:02:17 -0400
Received: from natasha.panasas.com ([67.152.220.90]:35824 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab2H1KCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 06:02:13 -0400
Message-ID: <503C9312.3070002@panasas.com>
Date: Tue, 28 Aug 2012 12:44:50 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        David Miller <davem@davemloft.net>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>,
        Dmitry Monakhov <dmonakhov@openvz.org>, Abhijith Das <adas@redhat.com>
Subject: Re: [PATCH] userns: Add basic quota support v2
References: <87lih2h6i4.fsf@xmission.com> <87harqecvk.fsf@xmission.com> <20120827085034.GA8998@quack.suse.cz> <87wr0j7u3j.fsf_-_@xmission.com> <20120828090544.GC5146@quack.suse.cz>
In-Reply-To: <20120828090544.GC5146@quack.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2012 12:05 PM, Jan Kara wrote:

>> +static inline u32 from_qown(struct user_namespace *user_ns, struct qown qown)
>> +{
>> +	switch (qown.type) {
>> +	case USRQUOTA:
>> +		return from_kuid(user_ns, qown.uid);
>> +	case GRPQUOTA:
>> +		return from_kgid(user_ns, qown.gid);
>> +	case XQM_PRJQUOTA:
>> +		return (user_ns == &init_user_ns) ? qown.prj : -1;
>> +	default:
>> +		BUG();
>> +	}
>> +}
>   I would like a bit more if the function somehow expressed in its name
> that it returns id. id_from_qown() might be a bit too long given how often
> it is used. qown2id() would be OK but it would be inconsistent with how
> names of other functions you've added are formed. So I'm somewhat
> undecided...
> 


qown_id()

> 								Honza


