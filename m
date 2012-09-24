Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab2IXHZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 03:25:56 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41607 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab2IXHZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 03:25:54 -0400
MIME-Version: 1.0
In-Reply-To: <5A9BC72FD5CEC94EA024CED8E31D701A4C572FAE@wdscexmb03.sc.wdc.com>
References: <CAHCeSFpar4ykz5cr9dLrO5J4r3ZXkwbNkU1O3q=QZs9rFEyB6w@mail.gmail.com>
	<20120921174952.GF7264@google.com>
	<CAHCeSFo0QtOc4GYfMqJy4R60G_Yy+1psidUbZ2=ym8XWraGvcw@mail.gmail.com>
	<20120921183515.GI7264@google.com>
	<CAHCeSFpa28d-7ruMKSw6z2EYKYN-5udVouUJOi4cnj4dPad-TA@mail.gmail.com>
	<20120921192720.GJ7264@google.com>
	<CAHCeSFrN6VketFq3vmA1S0O1GTOGNW41ZirZs5dGkiTXLbizkA@mail.gmail.com>
	<CAK7N6vpuJnnAp2xCUG_20aSVzT9aXhZRFrkVtfO3qOKE7gZ0Eg@mail.gmail.com>
	<5A9BC72FD5CEC94EA024CED8E31D701A4C572F72@wdscexmb03.sc.wdc.com>
	<CAK7N6vpLpNM-tfhxpmym_eW+VpF+jnBe+uB=E0mSBk+CtMWp+w@mail.gmail.com>
	<5A9BC72FD5CEC94EA024CED8E31D701A4C572FAE@wdscexmb03.sc.wdc.com>
Date: Mon, 24 Sep 2012 08:25:54 +0100
Message-ID: <CAHCeSFp2=CzO1-dw_Ym_s4Pn04nsC_kQUerFJ+uFLh8iinX+Ug@mail.gmail.com>
Subject: Re: Work queue questions
From: Deepawali Verma <dverma249@gmail.com>
To: Daniel Taylor <Daniel.Taylor@wdc.com>
Cc: anish singh <anish198519851985@gmail.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

Here are some code snippets from my device driver:

#defind NUMBER_OF_SUBTASKS 3

struct my_driver_object
{
        struct workqueue_struct *sub_task_wq;
        struct work_struct sub_task_work;
        char my_obj_wq_name[80];
        int task_id;
};

struct my_driver_object obj[3];


void my_driver_init(void)
{
   int i =0;
   memset(my_obj_wq_name,0,80);
  --------------------------------------
  for (i =0; i<3; i++)
  {
      snprintf(obj[i].my_obj_wq_name,80, "Task-wq:%d",i);
      obj.sub_task_wq = alloc_workqueue(obj[i].my_obj_wq_name,WQ_UNBOUND,1);
      INIT_WORK(&obj[i].sub_task_work, sub_task_work_handler);
  }

  --------------------------------------
}

void start_sub_tasks()
{
   int i =0;
   for (i =0; i<3; i++)
   {
        queue_work(obj[i].sub_task_wq, &obj[i].sub_task_work);

   }


}

static void sub_task_work_handler(struct work_struct work)
{
    Ftrace marker start;

    Ftrace marker end
}

Ideally I was expecting when work is queued to three different work
queues, it should run in parallel but it is not doing as per expected.
Let me know about this.

Regards,
Deepa







On Sat, Sep 22, 2012 at 7:18 AM, Daniel Taylor <Daniel.Taylor@wdc.com> wrote:
>
> ...
>
>> >> So on so forth.
>> >> Anyway how can you write chunks of data in parallel when
>> >> already some worker
>> >> thread is writing i.e. the system is busy.
>> >> Analogy: Suppose you are ambidextrous and you are eating.Can
>> >> you eat with
>> >> both of your hands at a time?So worker thread are like your
>> >> hands and keeping
>> >> you fed all the time is the concept of concurrency.
>> >>
>> >> I am not an expert on this but from Tejun's reply I could
>> >> make out this.
>> >> Please correct me If I have wrongly understood the concept
>> >> based on this mail
>> >
>> > I don't know how many cores are in the CPU Deepawali's
>> using, but if I have four,
>> Assuming single core,Is my explanation correct about concurrency?
>
> It is possible for his tasks to complete before scheduling occurs
> again.  Consuming all of the CPU and having no blocking action,
> yes, then the tasks will run consecutively.
>
> ...
