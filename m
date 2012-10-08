Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab2JHQfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 12:35:22 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:41384 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab2JHQfT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 12:35:19 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Changman Lee <cm224.lee@gmail.com>
Cc: =?utf-8?B?6rmA7J6s6re5?= <jaegeuk.kim@samsung.com>,
        "Theodore Ts'o" <tytso@mit.edu>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, jooyoung.hwang@samsung.com,
        viro@zeniv.linux.org.uk, chur.lee@samsung.com, cm224.lee@samsung.com
References: <001101cda2f1$50a23c40$f1e6b4c0$%kim@samsung.com>
	<87mx00slyj.fsf@xmission.com>
	<CAN863Pu_W4P74oQyJQnkXhUW+q-0zJR7F+gW_n6JqoOQOwG0ww@mail.gmail.com>
Date: Mon, 08 Oct 2012 09:35:08 -0700
In-Reply-To: <CAN863Pu_W4P74oQyJQnkXhUW+q-0zJR7F+gW_n6JqoOQOwG0ww@mail.gmail.com>
	(Changman Lee's message of "Mon, 8 Oct 2012 21:28:40 +0900")
Message-ID: <87r4p8gbwj.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19Q1yqmRwz1aPcT3+q2E0QcROf0Jyk33Do=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Changman Lee <cm224.lee@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 10/16] f2fs: add core inode operations
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changman Lee <cm224.lee@gmail.com> writes:
>> > +void update_inode(struct inode *inode, struct page *node_page)
>> > +{
>> > +     struct f2fs_node *rn;
>> > +     struct f2fs_inode *ri;
>> > +
>> > +     wait_on_page_writeback(node_page);
>> > +
>> > +     rn = page_address(node_page);
>> > +     ri = &(rn->i);
>> > +
>> > +     ri->i_mode = cpu_to_le16(inode->i_mode);
>> > +     ri->i_uid = cpu_to_le32(inode->i_uid);
>> > +     ri->i_gid = cpu_to_le32(inode->i_gid);
>> And make this:
>>         i_uid_write(inode, le32_to_cpu(ri->i_uid));
>>         i_gid_write(inode, le32_to_cpu(ri->i_gid));
>>
>
> You mean this. Right? :)
> ri->i_uid = cpu_to_le32(i_uid_read(inode));
> ri->i_gid = cpu_to_le32(i_gid_read(inode));

Yeah. ;)

I did have that one backwards.

Eric
