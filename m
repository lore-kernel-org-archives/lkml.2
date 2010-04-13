Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab0DMU0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 16:26:47 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:51380 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab0DMU0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:26:45 -0400
Message-ID: <4BC4D310.6060705@oracle.com>
Date: Tue, 13 Apr 2010 13:24:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Aristeu Rozanski <aris@redhat.com>
CC: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
       linux-kernel@vger.kernel.org, davej@redhat.com, kyle@redhat.com,
       vgoyal@redhat.com, arjan@linux.intel.com
Subject: Re: [PATCH] kconfig: introduce nonint_oldconfig and loose_nonint_oldconfig
References: <20100413194747.GX31193@redhat.com> <20100413130031.d4dec19b.randy.dunlap@oracle.com> <20100413201759.GY31193@redhat.com>
In-Reply-To: <20100413201759.GY31193@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4BC4D36F.0166:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/10 13:18, Aristeu Rozanski wrote:
>>> This patch has been around for a long time in Fedora and Red Hat Enterprise
>>> Linux kernels and it may be useful for others. The nonint_oldconfig target
>>> will fail and print the unset config options while loose_nonint_oldconfig will
>>> simply let the config option unset. They're useful in distro kernel packages
>>> where the config files are built using a combination of smaller config files.
>>> The patch's author AFAIK is Arjan van de Ven. Arjan, please add a Signed-off-by
>>> if you're the original author.
>>
>> Roland McGrath added the loose parts according to his email of 2008.Mar.05:
>> "I added this one (loose_nonint_oldconfig target, -B option to conf)."
> hm, I can't see the -B there, maybe the functionality he's referring to is
> the def_no?

+loose_nonint_oldconfig: $(obj)/conf
+	$< -B $(Kconfig)

...

+		case 'B':
+			input_mode = dont_ask_dont_tell;
+			break;


>> after Dave Jones posted this patch.
>>
>> (adding linux-kbuild mailing list & kbuild maintainer)
>>
>> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
>>
>>
>>
>>> Signed-off-by: Aristeu Rozanski <aris@redhat.com> 
>>
>>
>>> @@ -613,5 +641,5 @@ int main(int ac, char **av)
>>>  			exit(1);
>>>  		}
>>>  	}
>>> -	return 0;
>>> +	return return_value;
>>>  }
>>
>> Having 'make oldconfig' exit with Exit status: 139  (for example)
>> can be confusing.  I know that from experience.  It took me a bit
>> to find out what that meant.  That part could be improved...
> ok, no real reason to keep incrementing that. no different error codes exist
> other than "1". Do you think we need to introduce different return codes?
> 

I would prefer a fixed value, like 86.  or 11.  or a useful printf text message.

-- 
~Randy
