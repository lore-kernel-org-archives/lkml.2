Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab2DRDhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 23:37:34 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:50185 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab2DRDhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 23:37:33 -0400
Message-ID: <4F8E36FA.9070104@gmail.com>
Date: Tue, 17 Apr 2012 23:37:30 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: Doug Ledford <dledford@redhat.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, kosaki.motohiro@gmail.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Amerigo Wang <amwang@redhat.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [Patch 5/8] mqueue: revert bump up DFLT_*MAX
References: <cover.1334676645.git.dledford@redhat.com> <de8d761688dd34f312822db71ceed6753493933a.1334676645.git.dledford@redhat.com> <20120418032210.GB18830@mail.hallyn.com>
In-Reply-To: <20120418032210.GB18830@mail.hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(4/17/12 11:22 PM), Serge E. Hallyn wrote:
> Quoting Doug Ledford (dledford@redhat.com):
>> From: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
>>
>> Mqueue limitation is slightly naieve parameter likes other ipcs
>> because unprivileged user can consume kernel memory by using ipcs.
>>
>> Thus, too aggressive raise bring us security issue. Example,
>> current setting allow evil unprivileged user use 256GB (= 256
>> * 1024 * 1024*1024) and it's enough large to system will belome
>> unresponsive. Don't do that.
>>
>> Instead, every admin should adjust the knobs for their own systems.
>
> Would you be terribly averse to having a higher limit in init_ipc_ns,
> and the lower values by default in all child namespaces?

No, I just focused to don't create any regressions. i.e. I mainly focused
no namespace use case. And, I'm sorry, I don't think I clearly understand
recent namespace update. I'm not against any namespace enhancement. Please
only think just I don't understand neither a ipc namespace requirement nor
the code.



> Sorry it sounds from the intro like you've already had quite a bit of
> discussion on this...
>
> Of course I realize the values can just be raised by distro boot
> scripts...
