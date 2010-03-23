Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab0CWKys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 06:54:48 -0400
Received: from c11lh89h.securesites.net ([125.206.167.134]:3158 "EHLO
	c11lh89h.securesites.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab0CWKyq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 06:54:46 -0400
Subject: Re: Linux Checkpoint-Restart - v19
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Jiro SEKIBA <jir@dependable-os.net>
In-Reply-To: <4BA39971.2080402@cs.columbia.edu>
Date: Tue, 23 Mar 2010 19:53:44 +0900
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <FF5CB8EA-436D-4685-B7A2-946A83DF3F78@dependable-os.net>
References: <4B83106C.7040203@cs.columbia.edu> <a1c54a921003150155q4a0c7fc1vb02ba0464b07f452@mail.gmail.com> <4B9EBAF2.1060304@cs.columbia.edu> <0B4E8136-FFC6-490D-B04A-23A6E1A924FF@dependable-os.net> <20100317205556.GA20750@us.ibm.com> <EF179F3A-4FBA-4776-B7A4-48F5EF73DC9C@dependable-os.net> <4BA39971.2080402@cs.columbia.edu>
To: Oren Laadan <orenl@cs.columbia.edu>
X-Mailer: Apple Mail (2.1077)
X-VSS-HEADER: SID:023; PID:733; Tue, 23 Mar 2010 19:53:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
On 2010/03/20, at 0:34, Oren Laadan wrote:

> 
> 
> Jiro SEKIBA wrote:
>> Hi,
>> On 2010/03/18, at 5:55, Serge E. Hallyn wrote:
>>> Quoting Jiro SEKIBA (jir@dependable-os.net):
>>>> Hi,
>>>> 
>>>> Thank you for prompt reply!
>>>> Sorry that I didn't post to containers@lists.linux-foundation.org.
>>>> 
>>>> On 2010/03/16, at 7:55, Oren Laadan wrote:
>>>> 
>>>>> Hi,
>>>>> 
>>>>> Thanks for taking the time to evaluate c/r. You may want to also
>>>>> try the latest, which is (as of now) ckpt-v20-rc2.
>>>> Yeah, I'll eventually try to keep up with the latest,
>>>> but I just want to try the one  you think it's stable first anyway.
>>>> 
>>>>> In the future, please CC the containers mailing list for issues
>>>>> related to c/r, at "containers@lists.linux-foundation.org".
>>>>> 
>>>>> Jiro SEKIBA wrote:
>>>>>> Hi,
>>>>>> I'm trying to evaluate external checkpoint/restart with cr-v19 kernel.
>>>>>> However, when I restart, I got "Killed" message in stdout.
>>>>>> Do you have any tips or clue that are not in
>>>>>> Documentation/checkpoint/usage.txt ?
>>>>>> I'm using kernel pulled from
>>>>>> git://git.ncl.cs.columbia.edu/pub/git/linux-cr.git .
>>>>>> checkout tag named "ckpt-v19". Base distro is ubuntu 9.10.
>>>>>> I ran self checkpioint/restart sample program in Documentation/checkpint.
>>>>>> It works as written in usage.txt.
>>>>>> However, I can not make external checkpint/restart work properly.
>>>>>> I made a simple test program bellow and create checkpoint externally using
>>>>>> the program in Documentation/checkpoint/, it looks checkpoint file is
>>>>>> created properly.
>>>>>> However, when I ran self_restart < ckpt.image, I got "Killed" message.
>>>>> If you take an external checkpoint, then you need to match it
>>>>> with an external restart, as opposed to self_restart.
>>>>> 
>>>>> Otherwise, restarting with self_restart from a checkpoint that is
>>>>> not a self-checkpoint can yield unexpected results.
>>>>> 
>>>>> Since you don't mention in your post, I don't know if you are using
>>>>> the tools from user-cr. If not, then you should use 'checkpoint' and
>>>>> 'restart' tools from there. It is available from:
>>>>> 	git://git.ncl.cs.columbia.edu/pub/git/user-cr.git
>>>>> (use the same branch as the one you used to linux-cr).
>>>>> 
>>>>> Once you have the tools compiled, and you checkpoint with the
>>>>> 'checkpoint' utility from there, you can restart with:
>>>>> 	restart -v < ckpt.image
>>>>> 
>>>> Thank you for the information.
>>>> Actually I was trying to create checkpoint in Document/checkpints.
>>>> 
>>>> Now, I tried with user-cr, compiled binary in the same tag (ckpt-v19).
>>>> Creating checkpoint  looks OK and restart -v shows it Success.  nice!
>>>> However, the contents in /tmp/test.out never get further,
>>>> it remains same as when created checkpoint.
>>>> 
>>>> I tried  "./restart -F /cgroup/0 -v --no-pidns < ckpt.image", got Success.
>>>> cat /cgroup/0/tasks tells that there is a process.
>>>> ps shows ./test.  So, it looks restarting.
>>>> 
>>>> # ps axuww |grep $(cat /cgroup/0/tasks )
>>>> root      7231  0.1  0.0   1588    64 pts/0    D    16:57   0:00 ./test
>>>> root      7238  0.0  0.1   2716   660 pts/1    R+   16:57   0:00 grep 7231
>>>> 
>>>> under the /proc, one file descriptor opened, and it is /tmp/test.out
>>>> 
>>>> #  ls -l /proc/$(cat /cgroup/0/tasks)/fd
>>>> total 0
>>>> lrwx------ 1 root root 64 Mar 16 16:58 0 -> /tmp/test.out
>>>> 
>>>> Nhh, it's close..
>>>> 
>>>> I found that when I mount cgroup with -o freezer, self_checkpoint won't work.
>>>> It worked even I didn't mount the cgroup.
>>>> Is it what you expect?
>>> No, it is not.  Can you tell us more about exactly how it fails?
>>> 
>> OK, I've checked differences of dmesg when self_restart does well and doesn't.
>> When it goes well, the filename is /tmp/cr-self.out
>> [  401.522556] [2307:2307:c/r:ckpt_read_fname:571] read filename '/tmp/cr-self.out'
>> [  401.522558] [2307:2307:c/r:restore_open_fname:594] fname '/tmp/cr-self.out' flags 0x2
> 
> This means that restart wants to re-open the file /tmp/cr-self.out.
>> However, when the contents of file remains, filename is /tmp/cr-self.out.org,
>> which is , of course, the one of original file binding to the original process.
>> [ 1088.414250] [2951:2951:c/r:ckpt_read_fname:571] read filename '/tmp/cr-self.out.orig'
>> [ 1088.414253] [2951:2951:c/r:restore_open_fname:594] fname '/tmp/cr-self.out.orig' flags 0x2
> 
> This means that restart wants to re-open the file /tmp/cr-self.out.org.
> 
> Could it be that these two restart attempts use two distinct image files
> as input ?
> 
It's not, I ran same script that run, self_checkpoint, sleep, mv/cp file, and self_restasrt.
And sometime it's OK (means, cr.-self.out glows after restart), sometime it's not.

> The first one seems to correspond to something like:
> 1) start the test, 2) checkpoint, 3) mv file and cp file, 4) restart
> 
> The second one seems to correspond to something like:
> 1) start the test, 2) mv file and ctp file, 3) checkpoint, 4) restart
> 
> What is the actual error reported when it doesn't work ?  (from restart
> and from the kernel log)
> 

OK, that makes sense.  I tried following shell script.
If I sleep 4 instead of 3, I got expected result 100% so far

--------- self_checkpoint.sh ---------
./self_checkpoint > self.image &
sleep 3;
mv /tmp/cr-self.out /tmp/cr-self.out.orig;
cp /tmp/cr-self.out.orig /tmp/cr-self.out;

sed -i 's/count/xxxxx/g' /tmp/cr-self.out;

./self_restart < self.image
--------- self_checkpoint.sh ---------

self_restart.c creates self.image when counter i got 2,
it sleeps one second each time loop starts
So if I run the instructions in usage.txt by scripts, 
sleeping 3 seconds right after starting the self_checkpoint
may not enough sometime.


>> I can not reproduce yet, but at least cgroup freezer option won't affect like I mentioned.
>> Sorry that it might confuse you.
>> I still can not restart of external checkpoint.
>> I'll try to v20 next time.
> 
> If it doesn't work, can you please describe again the exact order of
> commands that you use and the reported error(s) ?
> 
I'll let you know in any cases.

Thank you very much for the advice

regards, 

> Oren.
> 
>>> Maybe get the cr_tests (either from Oren's tree or from
>>> git clone git://git.sr71.net/~hallyn/cr_tests.git), cd cr_test,
>>> make, cd simple, run ./ckpt and send us the contents of
>>> /tmp/log, dmesg, and ckptinfo -ve /tmp/out ?
>> I think it runs OK, but send it in case.
>> /tmp/log was empty by the way.
>> thanks
>>>> Thank you again for the help!
>>>> I'm feeling better to use the latest ..
>>> -serge

