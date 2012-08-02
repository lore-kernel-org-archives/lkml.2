Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab2HBQJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 12:09:47 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:37748 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab2HBQJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 12:09:44 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>, Tejun Heo <tj@kernel.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com
References: <20120731182330.GD21292@google.com> <50197348.9010101@gmail.com>
	<20120801182112.GC15477@google.com> <50197460.8010906@gmail.com>
	<20120801182749.GD15477@google.com> <50197E4A.7020408@gmail.com>
	<20120801202432.GE15477@google.com> <5019B0B4.1090102@gmail.com>
	<20120801224556.GF15477@google.com> <501A4FC1.8040907@gmail.com>
	<20120802103244.GA23318@leaf> <501A633B.3010509@gmail.com>
Date: Thu, 02 Aug 2012 09:03:49 -0700
In-Reply-To: <501A633B.3010509@gmail.com> (Sasha Levin's message of "Thu, 02
	Aug 2012 13:23:39 +0200")
Message-ID: <87txwl1dsq.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19bpa1y4Pm9GqvaITw1S9uUaMsL24DP5Mo=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Sasha Levin <levinsasha928@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC 1/4] hashtable: introduce a small and naive hashtable
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <levinsasha928@gmail.com> writes:
> On 08/02/2012 12:32 PM, Josh Triplett wrote:
>> What about using a C99 flexible array member?  Kernel style prohibits
>> variable-length arrays, but I don't think the same rationale applies to
>> flexible array members.
>> 
>> struct hash_table {
>>     size_t count;
>>     struct hlist_head buckets[];
>> };
>> 
>> #define DEFINE_HASH_TABLE(name, length) struct hash_table name = { .count = length, .buckets = { [0 ... (length - 1)] = HLIST_HEAD_INIT } }
>
> The limitation of this approach is that the struct hash_table variable
> must be 'static', which is a bit limiting - see for example the use of
> hashtable in 'struct user_namespace'.

You mean the hash table that was made static in 3.5?

You might want to try basing your patches on something a little more current.

Eric
