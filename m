Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab2I1BNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 21:13:38 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:52607 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386Ab2I1BNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 21:13:36 -0400
MIME-Version: 1.0
In-Reply-To: <5064EA5A.3080905@jp.fujitsu.com>
References: <1348724705-23779-1-git-send-email-wency@cn.fujitsu.com>
 <1348724705-23779-3-git-send-email-wency@cn.fujitsu.com> <CAHGf_=rLMsmAxR5hrDVXjkHAxmupVrmtqE3iq2qu=O9Prp4nSg@mail.gmail.com>
 <5064EA5A.3080905@jp.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Thu, 27 Sep 2012 21:13:13 -0400
X-Google-Sender-Auth: PWVi_rdlYyyY08qmRTTNHQqVl7Q
Message-ID: <CAHGf_=qbBGjTL9oBHz7AM8BAosbzvn_WAGdAzJ8np-nDPN_KFQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] memory-hotplug: add node_device_release
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: wency@cn.fujitsu.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, liuj97@gmail.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, minchan.kim@gmail.com,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 8:07 PM, Yasuaki Ishimatsu
<isimatu.yasuaki@jp.fujitsu.com> wrote:
> Hi Kosaki-san,
>
>
> 2012/09/28 5:13, KOSAKI Motohiro wrote:
>>
>> On Thu, Sep 27, 2012 at 1:45 AM,  <wency@cn.fujitsu.com> wrote:
>>>
>>> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>>>
>>> When calling unregister_node(), the function shows following message at
>>> device_release().
>>
>>
>> This description doesn't have the "following message".
>>
>>
>
>>> Device 'node2' does not have a release() function, it is broken and must
>>> be
>>> fixed.
>
>
> This is the messages. The message is shown by kobject_cleanup(), when
> calling
> unregister_node().

If so, you should quote the message. and don't mix it with your
subject. Moreover
your patch title is too silly. "add node_device_release() function" is
a way. you should
describe the effect of the patch. e.g. suppress "Device 'nodeXX' does
not have a release() function" warning.

Moreover, your explanation is still insufficient. Even if
node_device_release() is empty function, we can get rid of the
warning. Why do we need this node_device_release()
implementation?
